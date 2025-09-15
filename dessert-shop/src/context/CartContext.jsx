import {createContext, useContext, useState} from 'react';

const CartContext = createContext();

export const useCart = () => useContext(CartContext);

export function CartProvider({children}) {
    const [cart, setCart] = useState([]);

    const addToCart = (product) => {

        const numericPrice = parseFloat(product.price);
        if (isNaN(numericPrice)) {
            console.error("Product price is not a number:", product);
            return;
        }

        setCart((prevCart) => {
            const existingItem = prevCart.find((item) => item.id === product.id);

            if (existingItem) {
                return prevCart.map((item) =>
                    item.id === product.id ? {...item, quantity: item.quantity + 1} : item
                );
            } else {
                return [...prevCart, {...product, quantity: 1, price: numericPrice}];
            }
        });
    };

    const removeFromCart = (productId) => {
        setCart((prevCart) => prevCart.filter((item) => item.id !== productId));
    };

    const clearCart = () => {
        setCart([]);
    };

    const getTotal = () => {
        return cart.reduce((total, item) => total + item.price * item.quantity, 0);
    };

    return (
        <CartContext.Provider value={{cart, addToCart, removeFromCart, clearCart, getTotal}}>
            {children}
        </CartContext.Provider>
    );
}