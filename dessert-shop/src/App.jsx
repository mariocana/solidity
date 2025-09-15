import ProductList from './components/ProductList';
import Cart from './components/Cart';
import { CartProvider } from './context/CartContext';

export default function App() {
    return (
        <CartProvider>
            <main className="min-h-screen bg-[#fffaf7] px-4 py-6 font-sans">
                <div className="max-w-7xl mx-auto">
                    <h1 className="text-4xl font-bold text-gray-text mb-8">Desserts by Mario Canalella</h1>
                    <div className="flex flex-col lg:flex-row gap-8">
                        <ProductList />
                        <Cart />
                    </div>
                </div>
            </main>
        </CartProvider>
    );
}
