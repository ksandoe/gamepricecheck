import { useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import styles from './SearchBar.module.css';

export default function SearchBar() {
  const navigate = useNavigate();
  const [searchParams] = useSearchParams();
  const [query, setQuery] = useState(searchParams.get('q') ?? '');
  const [hasError, setHasError] = useState(false);

  function handleSubmit(event) {
    event.preventDefault();
    const trimmed = query.trim();
    if (!trimmed) {
      setHasError(true);
      return;
    }
    setHasError(false);
    navigate(`/search?${new URLSearchParams({ q: trimmed })}`);
  }

  return (
    <form role="search" className={styles.form} onSubmit={handleSubmit} noValidate>
      <label htmlFor="site-search" className="visually-hidden">
        Search games, consoles, and accessories
      </label>
      <input
        id="site-search"
        type="search"
        enterKeyHint="search"
        placeholder="Search games, consoles, accessories"
        value={query}
        maxLength={100}
        onChange={(event) => setQuery(event.target.value)}
        aria-invalid={hasError}
        aria-describedby={hasError ? 'site-search-error' : undefined}
        className={styles.input}
      />
      <button type="submit" className={styles.button}>
        Search
      </button>
      {hasError && (
        <p id="site-search-error" role="alert" className={styles.error}>
          Enter a product name to search.
        </p>
      )}
    </form>
  );
}
