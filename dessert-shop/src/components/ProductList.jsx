import { useEffect, useState } from 'react';
import ProductCard from './ProductCard';

export default function ProductList() {
    const [desserts, setDesserts] = useState([]);

    useEffect(() => {
        fetch('/data.json')
            .then((res) => res.json())
            .then(setDesserts);
    }, []);

    return (
        <section className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 flex-1">
            {desserts.map((dessert, index) => (
                <ProductCard key={index} product={dessert} />
            ))}
        </section>
    );
}
