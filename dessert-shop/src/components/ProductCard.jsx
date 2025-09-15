import { useCart } from '../context/CartContext';
import { ShoppingCart } from 'lucide-react';

export default function ProductCard({ product }) {
    const { addToCart } = useCart();
    const { image, name, category, price } = product;

    const getImagePath = (relativePath) => relativePath.replace('./', '/');

    return (
        <div className="bg-white shadow-md rounded-2xl overflow-hidden transition hover:shadow-lg">
            <picture>
                <source media="(min-width: 1024px)" srcSet={getImagePath(image.desktop)} />
                <source media="(min-width: 640px)" srcSet={getImagePath(image.tablet)} />
                <source media="(max-width: 639px)" srcSet={getImagePath(image.mobile)} />
                <img
                    src={getImagePath(image.thumbnail)}
                    alt={name}
                    className="w-full h-48 object-cover"
                />
            </picture>

            <div className="p-5">
                <p className="text-xs uppercase tracking-wide text-light-gray-text font-medium mb-1">{category}</p>
                <h3 className="text-lg font-semibold text-gray-text mb-1">{name}</h3>
                <p className="text-secondary-orange font-semibold mb-4">${price.toFixed(2)}</p>
                <button
                    onClick={() => addToCart(product)}
                    className="w-full flex items-center justify-center gap-2 px-4 py-2 border border-border-orange rounded-full text-sm text-primary-orange hover:bg-orange-50 transition"
                >
                    <ShoppingCart size={16} /> Add to Cart
                </button>
            </div>
        </div>
    );
}