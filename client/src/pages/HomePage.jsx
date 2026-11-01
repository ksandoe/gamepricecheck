import { Link } from 'react-router-dom';
import styles from './HomePage.module.css';

const CATEGORIES = [
  { value: 'game', label: 'Games' },
  { value: 'console', label: 'Consoles' },
  { value: 'accessory', label: 'Accessories' },
];

export default function HomePage() {
  return (
    <section>
      <h1 className={styles.heading}>Find the best price on physical games and gear</h1>
      <p className={styles.lead}>
        Search once and compare prices, condition, and availability across retailers and sellers.
      </p>
      <h2 className={styles.subheading}>Browse by category</h2>
      <ul className={styles.categories}>
        {CATEGORIES.map((category) => (
          <li key={category.value}>
            <Link to={`/search?category=${category.value}`} className={styles.category}>
              {category.label}
            </Link>
          </li>
        ))}
      </ul>
    </section>
  );
}
