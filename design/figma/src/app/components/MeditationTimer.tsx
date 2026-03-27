import React, { useState, useEffect } from 'react';
import { Play, Pause, RotateCcw } from 'lucide-react';
import { motion } from 'motion/react';
import { clsx } from 'clsx';

const PRESETS = [5, 10, 15, 20];

export const MeditationTimer = () => {
  const [duration, setDuration] = useState(5 * 60); // seconds
  const [timeLeft, setTimeLeft] = useState(5 * 60);
  const [isActive, setIsActive] = useState(false);

  useEffect(() => {
    let interval: NodeJS.Timeout;

    if (isActive && timeLeft > 0) {
      interval = setInterval(() => {
        setTimeLeft((prev) => prev - 1);
      }, 1000);
    } else if (timeLeft === 0) {
      setIsActive(false);
    }

    return () => clearInterval(interval);
  }, [isActive, timeLeft]);

  const toggleTimer = () => {
    setIsActive(!isActive);
  };

  const resetTimer = () => {
    setIsActive(false);
    setTimeLeft(duration);
  };

  const setPreset = (minutes: number) => {
    setIsActive(false);
    setDuration(minutes * 60);
    setTimeLeft(minutes * 60);
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const progress = ((duration - timeLeft) / duration) * 100;

  return (
    <div className="flex flex-col items-center justify-center min-h-[80%] p-6">
      
      {/* Circle Progress Timer */}
      <div className="relative w-64 h-64 mb-10 flex items-center justify-center">
        {/* SVG Circle for Progress */}
        <svg className="w-full h-full -rotate-90" viewBox="0 0 100 100">
          <circle
            className="text-slate-100"
            strokeWidth="4"
            stroke="currentColor"
            fill="transparent"
            r="45"
            cx="50"
            cy="50"
          />
          <motion.circle
            className="text-teal-500"
            strokeWidth="4"
            strokeLinecap="round"
            stroke="currentColor"
            fill="transparent"
            r="45"
            cx="50"
            cy="50"
            initial={{ pathLength: 0 }}
            animate={{ pathLength: 1 - (timeLeft / duration) }}
            transition={{ duration: 1, ease: "linear" }}
            style={{ pathLength: 1 - (timeLeft / duration) }} // Fallback/Force update
          />
        </svg>
        
        {/* Digital Time Display */}
        <div className="absolute flex flex-col items-center">
            <span className="text-5xl font-light text-slate-700 tracking-tighter tabular-nums">
                {formatTime(timeLeft)}
            </span>
            <span className="text-sm text-slate-400 font-medium uppercase tracking-widest mt-2">
                {isActive ? 'Meditando' : 'Pausado'}
            </span>
        </div>
      </div>

      {/* Controls */}
      <div className="flex items-center gap-6 mb-12">
        <button 
            onClick={resetTimer}
            className="w-12 h-12 rounded-full bg-slate-100 text-slate-500 flex items-center justify-center hover:bg-slate-200 transition-colors"
        >
            <RotateCcw size={20} />
        </button>

        <button 
            onClick={toggleTimer}
            className="w-20 h-20 rounded-full bg-teal-600 text-white shadow-xl shadow-teal-200 flex items-center justify-center hover:scale-105 active:scale-95 transition-all"
        >
            {isActive ? <Pause size={32} fill="currentColor" /> : <Play size={32} fill="currentColor" className="ml-2"/>}
        </button>
      </div>

      {/* Presets */}
      <div className="flex gap-3">
        {PRESETS.map(min => (
            <button
                key={min}
                onClick={() => setPreset(min)}
                className={clsx(
                    "px-4 py-2 rounded-full text-sm font-medium transition-all border",
                    duration === min * 60 
                        ? "bg-teal-50 border-teal-200 text-teal-700" 
                        : "bg-transparent border-slate-200 text-slate-500 hover:border-teal-200 hover:text-teal-600"
                )}
            >
                {min} min
            </button>
        ))}
      </div>
    </div>
  );
};
