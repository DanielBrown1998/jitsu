import React, { useState } from 'react';
import { PageTransition, Input, Button, Card, Belt, Badge, IconGi } from './JitsuDesignSystem';
import { User, Lock, Mail, ChevronRight, ArrowLeft } from 'lucide-react';

interface AuthProps {
  onLogin: (role: 'admin' | 'student') => void;
}

export const AuthScreen = ({ onLogin }: AuthProps) => {
  const [view, setView] = useState<'splash' | 'login' | 'recover'>('splash');
  const [email, setEmail] = useState('');

  // Auto-advance splash
  React.useEffect(() => {
    if (view === 'splash') {
      const timer = setTimeout(() => setView('login'), 2500);
      return () => clearTimeout(timer);
    }
  }, [view]);

  if (view === 'splash') {
    return (
      <div className="h-full bg-zinc-950 flex flex-col items-center justify-center p-8 relative overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-zinc-800 via-zinc-950 to-zinc-950 opacity-50" />
        <div className="z-10 animate-in fade-in zoom-in duration-1000 flex flex-col items-center">
           <div className="w-24 h-24 bg-white rounded-full flex items-center justify-center mb-6 shadow-[0_0_40px_rgba(255,255,255,0.2)]">
                <IconGi className="w-12 h-12 text-zinc-950" />
           </div>
           <h1 className="text-4xl font-black text-white tracking-tighter mb-2">JITSU</h1>
           <p className="text-zinc-500 tracking-widest text-xs uppercase">Academy Management</p>
        </div>
      </div>
    );
  }

  if (view === 'recover') {
    return (
        <PageTransition className="p-6 bg-zinc-50 justify-center">
            <button onClick={() => setView('login')} className="absolute top-8 left-6 text-zinc-500 hover:text-zinc-900">
                <ArrowLeft size={24} />
            </button>
            <div className="w-full max-w-sm mx-auto">
                <h2 className="text-2xl font-bold text-zinc-900 mb-2">Recuperar Senha</h2>
                <p className="text-zinc-500 mb-8 text-sm">Digite seu email para receber o link de redefinição.</p>
                <form className="flex flex-col gap-4" onSubmit={(e) => { e.preventDefault(); alert("Link enviado!"); setView('login'); }}>
                    <Input 
                        label="Email" 
                        type="email" 
                        placeholder="seu@email.com" 
                        icon={<Mail size={18} />} 
                        required
                    />
                    <Button type="submit" variant="primary">Enviar Link</Button>
                </form>
            </div>
        </PageTransition>
    )
  }

  // Login View
  return (
    <PageTransition className="p-6 bg-zinc-50 justify-center h-full">
      <div className="w-full max-w-sm mx-auto flex flex-col gap-6">
        <div className="text-center mb-4">
            <div className="w-16 h-16 bg-zinc-950 rounded-2xl mx-auto flex items-center justify-center mb-4 shadow-xl">
                 <IconGi className="w-8 h-8 text-white" />
            </div>
            <h2 className="text-2xl font-bold text-zinc-900">Bem-vindo de volta</h2>
            <p className="text-zinc-500 text-sm">Acesse sua conta para continuar</p>
        </div>

        <form className="flex flex-col gap-4" onSubmit={(e) => e.preventDefault()}>
            <Input 
                label="Email" 
                type="email" 
                placeholder="ex: admin@jitsu.com" 
                icon={<Mail size={18} />} 
                value={email}
                onChange={(e) => setEmail(e.target.value)}
            />
            <Input 
                label="Senha" 
                type="password" 
                placeholder="••••••••" 
                icon={<Lock size={18} />} 
            />
            <div className="flex justify-end">
                <button type="button" onClick={() => setView('recover')} className="text-xs font-medium text-zinc-600 hover:text-zinc-900">Esqueci a senha</button>
            </div>
            
            <div className="grid grid-cols-2 gap-3 pt-2">
                 <Button type="button" onClick={() => onLogin('student')} variant="outline">Sou Aluno</Button>
                 <Button type="submit" onClick={() => onLogin('admin')} variant="primary">Entrar <ChevronRight size={16} /></Button>
            </div>
        </form>

        <p className="text-center text-xs text-zinc-400 mt-8">Versão 1.0.0 • JITSU App</p>
      </div>
    </PageTransition>
  );
};
