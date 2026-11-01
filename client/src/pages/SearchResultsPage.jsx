import { useSearchParams } from 'react-router-dom';

// Placeholder: results list, filters, and sorting arrive in T-13 and T-21 to T-25.
export default function SearchResultsPage() {
  const [searchParams] = useSearchParams();
  const query = searchParams.get('q');
  const category = searchParams.get('category');

  return (
    <section>
      <h1>Search results</h1>
      <p>{query ? `Results for “${query}”` : `Browsing ${category ?? 'all products'}`}</p>
    </section>
  );
}
