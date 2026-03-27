import React, { useState, useRef, useEffect } from 'react';
import { Play, Pause, Volume2, VolumeX } from 'lucide-react';
import { motion } from 'motion/react';
import { clsx } from 'clsx';

// Placeholder images mapped to themes
const SOUNDS = [
  { id: 'rain', name: 'Chuva Suave', image: 'https://images.unsplash.com/photo-1759598322596-b9591ee32721?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxyYWluJTIwb24lMjB3aW5kb3clMjBjYWxtJTIwZGFya3xlbnwxfHx8fDE3NzAwNTI4MTl8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral' },
  { id: 'forest', name: 'Floresta Viva', image: 'https://images.unsplash.com/photo-1759334536558-84e96b73789c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb3Jlc3QlMjBuYXR1cmUlMjBncmVlbiUyMHRyZWVzJTIwc3VubGlnaHR8ZW58MXx8fHwxNzcwMDUyODE5fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral' },
  { id: 'ocean', name: 'Ondas do Mar', image: 'https://images.unsplash.com/photo-1560274445-18bd70cbb65f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxvY2VhbiUyMHdhdmVzJTIwYmVhY2glMjBjYWxtJTIwYmx1ZXxlbnwxfHx8fDE3NzAwNTI4MTl8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral' },
  { id: 'fire', name: 'Fogueira', image: 'https://images.unsplash.com/photo-1586071365462-b7d5c1b4cc29?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxib25maXJlJTIwY2FtcCUyMGZpcmUlMjBuaWdodCUyMGNvenl8ZW58MXx8fHwxNzcwMDUyODE5fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral' },
];

export const SoundPlayer = () => {
  const [activeSound, setActiveSound] = useState<string | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [volume, setVolume] = useState(0.5);

  // In a real app, we would manage Audio instances here.
  // For this demo, we simulate the state.
  
  const toggleSound = (id: string) => {
    if (activeSound === id) {
      if (isPlaying) {
        setIsPlaying(false);
        // audioRef.current.pause();
      } else {
        setIsPlaying(true);
        // audioRef.current.play();
      }
    } else {
      setActiveSound(id);
      setIsPlaying(true);
      // audioRef.current.src = `/sounds/${id}.mp3`;
      // audioRef.current.play();
    }
  };

  return (
    <div className="p-6 pb-24">
      <header className="mb-6">
        <h2 className="text-2xl font-semibold text-slate-800">Sons da Natureza</h2>
        <p className="text-slate-500 text-sm">Escolha um ambiente para relaxar.</p>
      </header>

      <div className="grid grid-cols-2 gap-4">
        {SOUNDS.map((sound) => (
          <SoundCard 
            key={sound.id} 
            sound={sound} 
            isActive={activeSound === sound.id}
            isPlaying={isPlaying && activeSound === sound.id}
            onClick={() => toggleSound(sound.id)}
          />
        ))}
      </div>

      {/* Mini Player Floating Bar (Visible when a sound is selected) */}
      <motion.div 
        initial={{ y: 100 }}
        animate={{ y: activeSound ? 0 : 100 }}
        className="fixed bottom-24 left-4 right-4 max-w-sm mx-auto bg-slate-900/90 backdrop-blur-md text-white p-4 rounded-2xl shadow-xl flex items-center justify-between z-40"
      >
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-lg overflow-hidden bg-slate-700">
             {activeSound && (
                 <img 
                    src={SOUNDS.find(s => s.id === activeSound)?.image} 
                    alt="Active" 
                    className="w-full h-full object-cover"
                 />
             )}
          </div>
          <div>
            <p className="text-sm font-medium">
                {activeSound ? SOUNDS.find(s => s.id === activeSound)?.name : 'Selecionar som'}
            </p>
            <p className="text-xs text-slate-400">Tocando agora</p>
          </div>
        </div>
        
        <div className="flex items-center gap-2">
            <button 
                onClick={() => setIsPlaying(!isPlaying)}
                className="w-10 h-10 bg-white text-slate-900 rounded-full flex items-center justify-center hover:scale-105 transition-transform"
            >
                {isPlaying ? <Pause size={18} fill="currentColor" /> : <Play size={18} fill="currentColor" className="ml-0.5" />}
            </button>
        </div>
      </motion.div>
    </div>
  );
};

const SoundCard = ({ sound, isActive, isPlaying, onClick }: any) => {
  return (
    <motion.button
      whileTap={{ scale: 0.95 }}
      onClick={onClick}
      className={clsx(
        "relative aspect-square rounded-2xl overflow-hidden group text-left",
        isActive ? "ring-4 ring-teal-500/50" : "hover:shadow-lg"
      )}
    >
      <img 
        src={sound.image} 
        alt={sound.name} 
        className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
      />
      <div className={clsx(
        "absolute inset-0 bg-black/30 transition-colors",
        isActive ? "bg-black/50" : "group-hover:bg-black/40"
      )} />
      
      <div className="absolute inset-0 p-4 flex flex-col justify-between text-white">
        <div className="self-end">
            {isActive && isPlaying && (
                <div className="flex gap-1 items-end h-4">
                    <motion.div 
                        animate={{ height: [4, 16, 8, 16, 4] }} 
                        transition={{ repeat: Infinity, duration: 1.2 }} 
                        className="w-1 bg-teal-400 rounded-full" 
                    />
                    <motion.div 
                        animate={{ height: [8, 4, 16, 8, 4] }} 
                        transition={{ repeat: Infinity, duration: 1.5 }} 
                        className="w-1 bg-teal-400 rounded-full" 
                    />
                    <motion.div 
                        animate={{ height: [12, 8, 4, 12] }} 
                        transition={{ repeat: Infinity, duration: 1.0 }} 
                        className="w-1 bg-teal-400 rounded-full" 
                    />
                </div>
            )}
        </div>
        <span className="font-medium text-lg tracking-wide">{sound.name}</span>
      </div>
    </motion.button>
  );
};
