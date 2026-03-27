import React from 'react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';
import { motion, AnimatePresence } from 'motion/react';
import { Loader2 } from 'lucide-react';

// --- UTILS ---
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// --- CONSTANTS ---
export const COLORS = {
  primary: '#000000',
  secondary: '#FFFFFF',
  accent: '#FFD700', // Gold
  success: '#22c55e', // Green-500
  danger: '#ef4444', // Red-500
  belts: {
    white: '#FFFFFF',
    blue: '#0066CC',
    purple: '#6B238E',
    brown: '#8B4513',
    black: '#000000',
  }
};

// --- ICONS (Custom SVGs) ---

export const IconGi = ({ className }: { className?: string }) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="M12 3L4 7V13C4 17.4183 7.58172 21 12 21C16.4183 21 20 17.4183 20 13V7L12 3Z" />
    <path d="M4 7L12 11L20 7" />
    <path d="M12 11V21" />
  </svg>
);

export const IconGuard = ({ className }: { className?: string }) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <circle cx="12" cy="5" r="3" />
    <path d="M5.5 12H18.5" />
    <path d="M12 12V20" />
    <path d="M8 20L5 16" />
    <path d="M16 20L19 16" />
  </svg>
);

export const IconMount = ({ className }: { className?: string }) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
     <circle cx="12" cy="7" r="3" />
     <path d="M8 12H16" />
     <path d="M9 12V18L5 22" />
     <path d="M15 12V18L19 22" />
  </svg>
);

// --- ATOMIC COMPONENTS ---

export const Button = ({ children, variant = 'primary', className, isLoading, ...props }: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger' | 'success', isLoading?: boolean }) => {
  const baseStyles = "h-12 px-6 rounded-xl font-medium transition-all active:scale-95 disabled:opacity-50 disabled:pointer-events-none flex items-center justify-center gap-2";
  const variants = {
    primary: "bg-zinc-950 text-white hover:bg-zinc-800 border border-transparent shadow-lg shadow-zinc-200",
    secondary: "bg-yellow-500 text-zinc-950 hover:bg-yellow-400 border border-transparent font-semibold",
    outline: "bg-transparent border-2 border-zinc-200 text-zinc-900 hover:border-zinc-900",
    ghost: "bg-transparent text-zinc-600 hover:bg-zinc-100",
    danger: "bg-red-600 text-white hover:bg-red-700 shadow-lg shadow-red-200",
    success: "bg-green-600 text-white hover:bg-green-700 shadow-lg shadow-green-200",
  };

  return (
    <button className={cn(baseStyles, variants[variant], className)} {...props}>
      {isLoading ? <Loader2 className="animate-spin w-5 h-5" /> : children}
    </button>
  );
};

export const Input = ({ label, icon, className, ...props }: React.InputHTMLAttributes<HTMLInputElement> & { label?: string, icon?: React.ReactNode }) => {
  return (
    <div className={cn("flex flex-col gap-1.5", className)}>
      {label && <label className="text-sm font-medium text-zinc-700">{label}</label>}
      <div className="relative">
        {icon && <div className="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400">{icon}</div>}
        <input 
          className={cn(
            "w-full h-12 bg-zinc-50 border border-zinc-200 rounded-xl px-4 text-zinc-900 focus:outline-none focus:ring-2 focus:ring-zinc-900 focus:border-transparent transition-all",
            icon && "pl-10"
          )}
          {...props} 
        />
      </div>
    </div>
  );
};

export const Card = ({ children, className, onClick }: { children: React.ReactNode, className?: string, onClick?: () => void }) => {
  return (
    <div onClick={onClick} className={cn("bg-white border border-zinc-100 rounded-2xl p-4 shadow-sm hover:shadow-md transition-all", onClick && "cursor-pointer active:scale-[0.98]", className)}>
      {children}
    </div>
  );
};

export const Badge = ({ children, variant = 'default', className }: { children: React.ReactNode, variant?: 'default' | 'success' | 'warning' | 'danger' | 'outline', className?: string }) => {
  const styles = {
    default: "bg-zinc-100 text-zinc-700",
    success: "bg-green-100 text-green-700",
    warning: "bg-yellow-100 text-yellow-800",
    danger: "bg-red-100 text-red-700",
    outline: "bg-transparent border border-zinc-200 text-zinc-600",
  };
  return (
    <span className={cn("px-2.5 py-0.5 rounded-full text-xs font-semibold whitespace-nowrap", styles[variant], className)}>
      {children}
    </span>
  );
};

// --- COMPLEX COMPONENTS ---

export type BeltColor = 'white' | 'blue' | 'purple' | 'brown' | 'black';

export const Belt = ({ color, stripes = 0, size = 'md', className }: { color: BeltColor, stripes?: number, size?: 'sm' | 'md' | 'lg', className?: string }) => {
  const bgColors = {
    white: 'bg-white border border-zinc-200',
    blue: 'bg-[#0066CC]',
    purple: 'bg-[#6B238E]',
    brown: 'bg-[#8B4513]',
    black: 'bg-black',
  };

  const barColor = color === 'black' ? 'bg-red-600' : 'bg-black';
  const sizes = {
    sm: "h-6 text-[10px]",
    md: "h-10 text-xs",
    lg: "h-16 text-sm",
  };

  return (
    <div className={cn("relative w-full rounded-lg shadow-md flex items-center overflow-hidden", bgColors[color], sizes[size], className)}>
        {/* Fabric Texture Overlay */}
        <div className="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/fabric-of-squares.png')] opacity-10 pointer-events-none"></div>

        {/* Branding Tag (Simulated) */}
        {size !== 'sm' && (
             <div className="absolute left-4 bg-black/20 px-2 py-0.5 rounded text-white/50 font-bold tracking-widest uppercase">
                JITSU
             </div>
        )}

        {/* Rank Bar */}
        <div className={cn("absolute right-0 h-full w-[25%] flex items-center justify-around px-1", barColor)}>
            {[...Array(4)].map((_, i) => (
                <div 
                    key={i} 
                    className={cn(
                        "w-1.5 h-[80%] bg-white rounded-sm shadow-sm transform transition-all",
                        i < stripes ? "opacity-100" : "opacity-0"
                    )}
                />
            ))}
        </div>
    </div>
  );
};

// --- ANIMATION WRAPPERS ---

export const PageTransition = ({ children, className }: { children: React.ReactNode, className?: string }) => (
  <motion.div
    initial={{ opacity: 0, x: 10 }}
    animate={{ opacity: 1, x: 0 }}
    exit={{ opacity: 0, x: -10 }}
    transition={{ duration: 0.3 }}
    className={cn("w-full h-full flex flex-col", className)}
  >
    {children}
  </motion.div>
);
