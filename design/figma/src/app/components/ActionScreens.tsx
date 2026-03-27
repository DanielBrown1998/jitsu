import React, { useState } from 'react';
import { PageTransition, Card, Button, Belt, Badge, cn } from './JitsuDesignSystem';
import { CheckSquare, ChevronLeft, Calendar, UserCheck, Star, Trophy, X, Check } from 'lucide-react';
import { motion } from 'motion/react';

const ATTENDANCE_MOCK = [
    { id: 1, name: 'Carlos Silva', rank: 'white', stripes: 3, present: false },
    { id: 2, name: 'Mariana Costa', rank: 'blue', stripes: 1, present: false },
    { id: 4, name: 'Ana Oliveira', rank: 'purple', stripes: 2, present: false },
    { id: 5, name: 'Lucas Ferreira', rank: 'white', stripes: 4, present: false },
];

export const AttendanceSelect = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('admin_home')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Chamada</h1>
            </div>

            <div className="p-4 space-y-4">
                <h3 className="text-sm font-semibold text-zinc-500 uppercase tracking-wide">Turmas de Hoje</h3>
                {[
                    { time: '07:00', name: 'Fundamentals', count: 12, checked: true },
                    { time: '12:00', name: 'Competition', count: 18, checked: false },
                    { time: '18:30', name: 'Kids Beginner', count: 24, checked: false },
                    { time: '20:00', name: 'Advanced', count: 15, checked: false },
                ].map((item, idx) => (
                    <Card key={idx} onClick={() => !item.checked && navigateTo('attendance_register')} className={cn("flex items-center p-4 gap-4", item.checked ? "opacity-60 bg-zinc-50" : "hover:border-zinc-300")}>
                        <div className={cn("w-12 h-12 rounded-xl flex items-center justify-center font-bold text-sm", item.checked ? "bg-green-100 text-green-700" : "bg-zinc-100 text-zinc-700")}>
                            {item.checked ? <Check size={20} /> : item.time}
                        </div>
                        <div className="flex-1">
                            <h4 className="font-bold text-zinc-900">{item.name}</h4>
                            <p className="text-xs text-zinc-500">{item.count} alunos matriculados</p>
                        </div>
                        <ChevronLeft className="rotate-180 text-zinc-300" size={20} />
                    </Card>
                ))}
            </div>
        </PageTransition>
    )
}

export const AttendanceRegister = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    const [students, setStudents] = useState(ATTENDANCE_MOCK);
    const [technique, setTechnique] = useState('');

    const toggle = (id: number) => {
        setStudents(s => s.map(st => st.id === id ? { ...st, present: !st.present } : st));
    }

    const confirm = () => {
        navigateTo('attendance_success');
    }

    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-32">
             <div className="bg-zinc-900 text-white px-4 py-6 rounded-b-3xl shadow-lg sticky top-0 z-20">
                <div className="flex items-center gap-4 mb-4">
                    <button onClick={() => navigateTo('attendance_select')} className="p-2 hover:bg-white/10 rounded-full"><ChevronLeft /></button>
                    <div>
                         <h1 className="text-lg font-bold">Competition Class</h1>
                         <p className="text-xs text-zinc-400">12:00 • Prof. Galvão</p>
                    </div>
                </div>
                <div className="bg-zinc-800 rounded-xl p-3 flex items-center gap-3">
                    <Star className="text-yellow-500" size={16} />
                    <input 
                        type="text" 
                        placeholder="Técnica do dia (Opcional)"
                        className="bg-transparent border-none text-sm text-white placeholder-zinc-500 focus:outline-none w-full"
                        value={technique}
                        onChange={(e) => setTechnique(e.target.value)}
                    />
                </div>
            </div>

            <div className="p-4 space-y-3">
                <div className="flex justify-between items-center px-1">
                    <span className="text-xs font-bold text-zinc-400 uppercase">Alunos ({students.filter(s => s.present).length}/{students.length})</span>
                    <button onClick={() => setStudents(s => s.map(st => ({...st, present: true})))} className="text-xs text-blue-600 font-medium">Marcar Todos</button>
                </div>

                {students.map(student => (
                    <div key={student.id} onClick={() => toggle(student.id)} className={cn("bg-white p-3 rounded-xl border flex items-center gap-3 transition-all", student.present ? "border-green-500 bg-green-50" : "border-zinc-100")}>
                        <div className={cn("w-6 h-6 rounded border flex items-center justify-center transition-colors", student.present ? "bg-green-500 border-green-500" : "border-zinc-300 bg-white")}>
                            {student.present && <Check size={14} className="text-white" />}
                        </div>
                        <div className="flex-1">
                            <h3 className="font-semibold text-sm text-zinc-900">{student.name}</h3>
                            <div className="w-16 mt-1">
                                <Belt color={student.rank as any} stripes={student.stripes} size="sm" />
                            </div>
                        </div>
                    </div>
                ))}
            </div>

            <div className="fixed bottom-0 w-full max-w-md bg-white p-4 border-t border-zinc-100">
                <Button onClick={confirm} className="w-full" variant="primary">Confirmar Presença</Button>
            </div>
        </PageTransition>
    )
}

export const AttendanceSuccess = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <div className="h-full bg-green-500 text-white flex flex-col items-center justify-center p-8 text-center">
            <motion.div 
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                className="w-24 h-24 bg-white rounded-full flex items-center justify-center mb-6 shadow-xl"
            >
                <Check size={48} className="text-green-600" strokeWidth={4} />
            </motion.div>
            <h1 className="text-3xl font-bold mb-2">Sucesso!</h1>
            <p className="text-green-100 mb-8">Presença registrada para 4 alunos.</p>
            <Button onClick={() => navigateTo('admin_home')} className="bg-white text-green-700 hover:bg-green-50 w-full max-w-xs">Voltar ao Início</Button>
        </div>
    )
}

export const GraduationList = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
     return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('admin_home')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Graduação</h1>
            </div>

            <div className="p-4 space-y-4">
                <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 flex gap-3">
                    <Trophy className="text-yellow-600 shrink-0" size={20} />
                    <p className="text-xs text-yellow-800">Alunos listados abaixo atingiram o número mínimo de aulas para graduação.</p>
                </div>

                {[
                    { id: 5, name: 'Lucas Ferreira', current: { rank: 'white', stripes: 4 }, next: { rank: 'blue', stripes: 0 } },
                    { id: 2, name: 'Mariana Costa', current: { rank: 'blue', stripes: 1 }, next: { rank: 'blue', stripes: 2 } },
                ].map(student => (
                    <Card key={student.id} className="p-4 relative overflow-hidden">
                        <div className="flex justify-between items-start mb-4">
                             <div>
                                <h3 className="font-bold text-zinc-900">{student.name}</h3>
                                <div className="flex items-center gap-1 text-xs text-green-600 font-medium mt-1">
                                    <CheckSquare size={12} /> Critérios atendidos
                                </div>
                             </div>
                             <img src={`https://i.pravatar.cc/150?u=${student.id}`} className="w-10 h-10 rounded-full" />
                        </div>

                        <div className="flex items-center gap-2 mb-4">
                            <div className="flex-1">
                                <span className="text-[10px] text-zinc-500 uppercase">Atual</span>
                                <Belt color={student.current.rank as any} stripes={student.current.stripes} size="sm" />
                            </div>
                            <div className="text-zinc-300"><ChevronLeft className="rotate-180" /></div>
                             <div className="flex-1">
                                <span className="text-[10px] text-zinc-500 uppercase">Nova</span>
                                <Belt color={student.next.rank as any} stripes={student.next.stripes} size="sm" />
                            </div>
                        </div>

                        <Button onClick={() => navigateTo('graduation_promote')} variant="secondary" className="w-full h-10 text-sm">Promover Aluno</Button>
                    </Card>
                ))}
            </div>
        </PageTransition>
     )
}

export const GraduationPromote = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('graduation_list')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Promover Aluno</h1>
            </div>

            <div className="p-6 flex flex-col items-center text-center space-y-6">
                <div className="w-24 h-24 rounded-full border-4 border-white shadow-xl overflow-hidden">
                    <img src="https://i.pravatar.cc/150?u=5" className="w-full h-full object-cover" />
                </div>
                
                <div>
                    <h2 className="text-2xl font-bold text-zinc-900">Lucas Ferreira</h2>
                    <p className="text-zinc-500">Faixa Branca (4 graus) &rarr; <span className="text-blue-600 font-bold">Faixa Azul</span></p>
                </div>

                <div className="w-full space-y-2">
                    <Belt color="white" stripes={4} size="md" className="opacity-50" />
                    <div className="flex justify-center text-zinc-300"><ChevronLeft className="rotate-270" /></div>
                    <Belt color="blue" stripes={0} size="lg" className="shadow-xl scale-105" />
                </div>

                <div className="w-full text-left pt-6">
                    <label className="text-sm font-medium text-zinc-700">Observações (opcional)</label>
                    <textarea className="w-full h-24 mt-1 bg-white border border-zinc-200 rounded-xl p-3 text-sm resize-none focus:outline-none focus:border-zinc-900" placeholder="Ex: Demonstrou excelência técnica..." />
                </div>
            </div>

            <div className="p-4 bg-white border-t border-zinc-100 fixed bottom-0 w-full max-w-md grid grid-cols-2 gap-4">
                <Button variant="outline" onClick={() => navigateTo('graduation_list')}>Cancelar</Button>
                <Button variant="primary" onClick={() => navigateTo('graduation_success')}>Confirmar</Button>
            </div>
        </PageTransition>
    )
}

export const GraduationSuccess = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <div className="h-full bg-zinc-950 flex flex-col items-center justify-center p-8 text-center relative overflow-hidden">
            {/* Simple confetti simulation using dots */}
            {[...Array(20)].map((_, i) => (
                <motion.div 
                    key={i}
                    className="absolute w-2 h-2 bg-yellow-500 rounded-full"
                    initial={{ y: -20, x: Math.random() * 300, opacity: 1 }}
                    animate={{ y: 800, rotate: 360 }}
                    transition={{ duration: 2 + Math.random(), repeat: Infinity, ease: "linear" }}
                    style={{ left: `${Math.random() * 100}%` }}
                />
            ))}

            <motion.div 
                initial={{ scale: 0.5, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ type: "spring" }}
                className="relative z-10 w-full flex flex-col items-center"
            >
                <div className="text-yellow-500 mb-4"><Trophy size={64} /></div>
                <h1 className="text-4xl font-black text-white italic tracking-tighter uppercase mb-2">Parabéns!</h1>
                <p className="text-zinc-400 mb-8">Lucas Ferreira foi promovido.</p>
                
                <div className="w-full max-w-xs mb-12 transform -rotate-3 hover:rotate-0 transition-transform duration-500">
                    <Belt color="blue" stripes={0} size="lg" className="shadow-[0_0_30px_rgba(37,99,235,0.5)]" />
                </div>

                <Button onClick={() => navigateTo('admin_home')} variant="secondary" className="w-full max-w-xs">Voltar</Button>
            </motion.div>
        </div>
    )
}
