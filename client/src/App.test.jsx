import { describe, expect, it } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { MemoryRouter } from 'react-router-dom';
import App from './App.jsx';

function renderAt(path) {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <App />
    </MemoryRouter>,
  );
}

describe('App', () => {
  it('renders the home page with category shortcuts', () => {
    renderAt('/');
    expect(screen.getByRole('heading', { level: 1 })).toHaveTextContent(/best price/i);
    expect(screen.getByRole('link', { name: 'Consoles' })).toHaveAttribute(
      'href',
      '/search?category=console',
    );
  });

  it('navigates to search results when a query is submitted', async () => {
    renderAt('/');
    await userEvent.type(screen.getByLabelText(/search games/i), 'zelda{Enter}');
    expect(screen.getByText('Results for “zelda”')).toBeInTheDocument();
  });

  it('shows a validation message for an empty search', async () => {
    renderAt('/');
    await userEvent.click(screen.getByRole('button', { name: 'Search' }));
    expect(screen.getByRole('alert')).toHaveTextContent(/enter a product name/i);
  });

  it('shows a not-found page for unknown routes', () => {
    renderAt('/nope');
    expect(screen.getByRole('heading', { name: 'Page not found' })).toBeInTheDocument();
  });
});
