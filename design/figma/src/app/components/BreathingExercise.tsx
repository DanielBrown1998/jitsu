import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Play, Pause, RefreshCw } from 'lucide-react';

export const BreathingExercise = () => {
  const [isActive, setIsActive] = useState(false);
  const [phase, setPhase] = useState<'inhale' | 'hold' | 'exhale' | 'idle'>('idle');
  const [instruction, setInstruction] = useState('Toque para iniciar');
  const [progress, setProgress] = useState(0);

  // Phases config (in seconds)
  const INHALE_TIME = 4;
  const HOLD_TIME = 4; // Simplified 4-4-4 for easier demo, or stick to 4-7-8
  const EXHALE_TIME = 4; 
  
  // Total cycle time logic handled in effect
  
  useEffect(() => {
    let timer: NodeJS.Timeout;
    let cycleTimer: NodeJS.Timeout;

    if (isActive) {
      const runCycle = async () => {
        // Inhale
        setPhase('inhale');
        setInstruction('Inspire...');
        await new Promise(r => setTimeout(r, INHALE_TIME * 1000));
        
        if (!isActive) return;

        // Hold
        setPhase('hold');
        setInstruction('Segure...');
        await new Promise(r => setTimeout(r, HOLD_TIME * 1000));

        if (!isActive) return;

        // Exhale
        setPhase('exhale');
        setInstruction('Expire...');
        await new Promise(r => setTimeout(r, EXHALE_TIME * 1000));
        
        // Loop is handled by the useEffect dependency on isActive, but pure recursion is safer here or just a loop
      };

      // Simple loop mechanism
      const loop = () => {
        setPhase('inhale');
        setInstruction('Inspire...');
        
        setTimeout(() => {
            if (!isActive) return;
            setPhase('hold');
            setInstruction('Segure...');
            
            setTimeout(() => {
                if (!isActive) return;
                setPhase('exhale');
                setInstruction('Expire...');
            }, HOLD_TIME * 1000);

        }, INHALE_TIME * 1000);
      };

      // Initial start
      loop();
      
      // Set interval for subsequent loops
      const totalCycle = (INHALE_TIME + HOLD_TIME + EXHALE_TIME) * 1000;
      cycleTimer = setInterval(loop, totalCycle);
    } else {
      setPhase('idle');
      setInstruction('Toque para iniciar');
      if (cycleTimer!) clearInterval(cycleTimer);
    }

    return () => {
      clearTimeout(timer);
      clearInterval(cycleTimer);
    };
  }, [isActive]);

  const toggleSession = () => {
    setIsActive(!isActive);
  };

  // Animation variants
  const circleVariants = {
    idle: { scale: 1, opacity: 0.5 },
    inhale: { scale: 2.5, opacity: 1, transition: { duration: INHALE_TIME, ease: "easeInOut" } },
    hold: { scale: 2.5, opacity: 0.8, transition: { duration: HOLD_TIME } },
    exhale: { scale: 1, opacity: 0.5, transition: { duration: EXHALE_TIME, ease: "easeInOut" } }
  };

  const textVariants = {
    initial: { opacity: 0, y: 10 },
    animate: { opacity: 1, y: 0 },
    exit: { opacity: 0, y: -10 }
  };

  return (
    <div className="flex flex-col items-center justify-center h-full w-full bg-gradient-to-b from-teal-50 to-white p-6">
      <h2 className="text-2xl font-semibold text-teal-800 mb-8 tracking-tight">Respiração Guiada</h2>

      <div className="relative w-64 h-64 flex items-center justify-center mb-12">
        {/* Background Rings */}
        <div className="absolute inset-0 rounded-full border border-teal-100 scale-150 opacity-30" />
        <div className="absolute inset-0 rounded-full border border-teal-100 scale-200 opacity-20" />
        
        {/* Animated Circle */}
        <motion.div
          className="w-32 h-32 bg-teal-300/40 rounded-full blur-xl absolute"
          variants={circleVariants}
          animate={phase}
        />
        <motion.div
          className="w-32 h-32 bg-gradient-to-tr from-teal-400 to-emerald-300 rounded-full shadow-lg z-10 flex items-center justify-center relative"
          variants={circleVariants}
          animate={phase}
        >
             {/* Inner white glow */}
             <div className="w-full h-full rounded-full bg-white opacity-20 blur-md absolute" />
        </motion.div>

        {/* Text Instructions */}
        <div className="absolute z-20 pointer-events-none">
             <AnimatePresence mode='wait'>
                <motion.span 
                    key={instruction}
                    variants={textVariants}
                    initial="initial"
                    animate="animate"
                    exit="exit"
                    className="text-teal-900 font-medium text-lg tracking-widest uppercase mix-blend-multiply"
                >
                    {isActive ? instruction : "Iniciar"}
                </motion.span>
             </AnimatePresence>
        </div>
      </div>

      {/* Controls */}
      <div className="flex gap-6 mt-8">
        <button
          onClick={toggleSession}
          className="p-4 bg-teal-600 text-white rounded-full shadow-lg hover:bg-teal-700 hover:scale-105 active:scale-95 transition-all"
        >
          {isActive ? <Pause fill="currentColor" /> : <Play fill="currentColor" className="ml-1" />}
        </button>
      </div>
      
      <p className="mt-8 text-slate-400 text-sm max-w-xs text-center">
        Siga o ritmo do círculo para acalmar sua mente e reduzir o estresse.
      </p>
    </div>
  );
};
