import React from 'react';
import { Home, Wind, Music, Settings } from 'lucide-react';
import { motion } from 'motion/react';
import { clsx } from 'clsx';

interface LayoutProps {
  children: React.ReactNode;
  activeTab: 'home' | 'breathe' | 'sounds';
  onTabChange: (tab: 'home' | 'breathe' | 'sounds') => void;
}

export const Layout = ({ children, activeTab, onTabChange }: LayoutProps) => {
  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center font-sans text-slate-800">
      {/* Mobile container */}
      <div className="w-full max-w-md h-[100dvh] bg-white shadow-2xl overflow-hidden relative flex flex-col sm:rounded-3xl sm:h-[90vh] sm:border sm:border-slate-200">
        
        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto overflow-x-hidden relative">
            {children}
        </main>

        {/* Bottom Navigation */}
        <nav className="h-20 bg-white/90 backdrop-blur-md border-t border-slate-100 flex justify-around items-center px-4 pb-2 z-50">
          <NavButton 
            active={activeTab === 'home'} 
            onClick={() => onTabChange('home')} 
            icon={<Home size={24} />} 
            label="Início" 
          />
          <NavButton 
            active={activeTab === 'breathe'} 
            onClick={() => onTabChange('breathe')} 
            icon={<Wind size={24} />} 
            label="Respirar" 
          />
          <NavButton 
            active={activeTab === 'sounds'} 
            onClick={() => onTabChange('sounds')} 
            icon={<Music size={24} />} 
            label="Sons" 
          />
        </nav>
      </div>
    </div>
  );
};

const NavButton = ({ active, onClick, icon, label }: { active: boolean, onClick: () => void, icon: React.ReactNode, label: string }) => {
  return (
    <button 
      onClick={onClick}
      className={clsx(
        "flex flex-col items-center justify-center w-16 h-16 rounded-2xl transition-all duration-300",
        active ? "text-teal-600 scale-105" : "text-slate-400 hover:text-slate-600"
      )}
    >
      <div className={clsx(
        "mb-1 p-1 rounded-full transition-colors",
        active ? "bg-teal-50" : "bg-transparent"
      )}>
        {icon}
      </div>
      <span className="text-[10px] font-medium tracking-wide">{label}</span>
    </button>
  );
}
