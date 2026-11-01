import { useParams } from 'react-router-dom';

// Placeholder: product details and seller comparison arrive in T-40 and T-31.
export default function ProductPage() {
  const { id } = useParams();

  return (
    <section>
      <h1>Product</h1>
      <p>Product {id}</p>
    </section>
  );
}
