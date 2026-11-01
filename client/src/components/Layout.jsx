import { Link, Outlet } from 'react-router-dom';
import SearchBar from './SearchBar.jsx';
import styles from './Layout.module.css';

export default function Layout() {
  return (
    <div className={styles.app}>
      <header className={styles.header}>
        <div className={styles.headerInner}>
          <Link to="/" className={styles.brand}>
            GamePriceCheck
          </Link>
          <SearchBar />
        </div>
      </header>
      <main className={styles.main}>
        <Outlet />
      </main>
      <footer className={styles.footer}>
        <Link to="/about">About &amp; help</Link>
        <p>Prices are informational. Purchases are completed on the seller&apos;s website.</p>
      </footer>
    </div>
  );
}
