import React, { useState } from 'react';
import { PageTransition, Card, Button, Belt, Badge, IconGi, IconGuard, IconMount, cn } from './JitsuDesignSystem';
import { 
    Users, CalendarCheck, GraduationCap, Trophy, ChevronRight, 
    TrendingUp, Calendar, Filter, Search, MoreVertical, X, Check,
    AlertCircle, FileText
} from 'lucide-react';
import { motion } from 'motion/react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, Cell } from 'recharts';


// --- MOCK DATA ---
const STUDENTS = [
  { id: 1, name: 'Carlos Silva', rank: 'white', stripes: 3, status: 'active', classes: 24, nextGrad: 30 },
  { id: 2, name: 'Mariana Costa', rank: 'blue', stripes: 1, status: 'active', classes: 85, nextGrad: 120 },
  { id: 3, name: 'Pedro Santos', rank: 'white', stripes: 0, status: 'inactive', classes: 2, nextGrad: 30 },
  { id: 4, name: 'Ana Oliveira', rank: 'purple', stripes: 2, status: 'active', classes: 210, nextGrad: 250 },
  { id: 5, name: 'Lucas Ferreira', rank: 'white', stripes: 4, status: 'active', classes: 32, nextGrad: 30 }, // Eligible
];

const CLASSES = [
    { id: 1, time: '07:00', name: 'Jiu-Jitsu Fundamentals', instructor: 'Mestre Rickson', type: 'Adulto', students: 12 },
    { id: 2, time: '12:00', name: 'Competition Class', instructor: 'Prof. Galvão', type: 'Adulto', students: 18 },
    { id: 3, time: '18:30', name: 'Kids Beginner', instructor: 'Inst. Bia', type: 'Kids', students: 24 },
];

const HISTORY = [
    { date: '12 Out', prev: 'Branca (2 graus)', next: 'Branca (3 graus)', note: 'Ótima evolução na guarda.' },
    { date: '15 Ago', prev: 'Branca (1 grau)', next: 'Branca (2 graus)', note: 'Consistência nos treinos.' },
];

// --- SUB-COMPONENTS ---

const QuickAction = ({ icon, label, onClick, color = "bg-zinc-100" }: any) => (
    <button onClick={onClick} className="flex flex-col items-center gap-2 group">
        <div className={cn("w-14 h-14 rounded-2xl flex items-center justify-center text-zinc-800 shadow-sm group-active:scale-95 transition-all", color)}>
            {icon}
        </div>
        <span className="text-[10px] font-medium text-zinc-600 text-center leading-tight">{label}</span>
    </button>
);

const StatCard = ({ label, value, icon, trend }: any) => (
    <Card className="flex flex-col gap-1 p-3">
        <div className="flex justify-between items-start">
            <span className="text-zinc-500 text-xs font-medium uppercase tracking-wider">{label}</span>
            <div className="text-zinc-400">{icon}</div>
        </div>
        <div className="text-2xl font-bold text-zinc-900">{value}</div>
        {trend && <span className="text-[10px] text-green-600 font-medium flex items-center gap-0.5"><TrendingUp size={10} /> {trend}</span>}
    </Card>
);

// --- DASHBOARDS ---

export const AdminDashboard = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="p-4 space-y-6 pb-24">
            {/* Header */}
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-2xl font-bold text-zinc-900">Dashboard</h1>
                    <p className="text-zinc-500 text-sm">Visão geral da academia</p>
                </div>
                <div className="w-10 h-10 bg-zinc-200 rounded-full overflow-hidden border-2 border-white shadow-sm">
                    <img src="https://i.pravatar.cc/150?u=admin" alt="Admin" />
                </div>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-2 gap-3">
                <StatCard label="Total Alunos" value="124" icon={<Users size={16} />} trend="+12% este mês" />
                <StatCard label="Aulas Hoje" value="4" icon={<CalendarCheck size={16} />} />
                <StatCard label="Elegíveis" value="8" icon={<GraduationCap size={16} />} />
                <StatCard label="Turmas Ativas" value="12" icon={<Trophy size={16} />} />
            </div>

            {/* Quick Actions */}
            <div>
                <h3 className="text-sm font-semibold text-zinc-900 mb-3">Acesso Rápido</h3>
                <div className="flex gap-4 overflow-x-auto pb-2 scrollbar-hide">
                    <QuickAction onClick={() => navigateTo('attendance_select')} icon={<Check size={24} />} label="Chamada" color="bg-green-100 text-green-800" />
                    <QuickAction onClick={() => navigateTo('students_new')} icon={<Users size={24} />} label="Novo Aluno" />
                    <QuickAction onClick={() => navigateTo('graduation_list')} icon={<GraduationCap size={24} />} label="Graduar" color="bg-yellow-100 text-yellow-800" />
                    <QuickAction onClick={() => navigateTo('reports')} icon={<FileText size={24} />} label="Relatórios" />
                </div>
            </div>

            {/* Recent Activity / Classes */}
            <div>
                <div className="flex justify-between items-center mb-3">
                     <h3 className="text-sm font-semibold text-zinc-900">Turmas de Hoje</h3>
                     <button className="text-xs text-zinc-500 hover:text-zinc-900">Ver todas</button>
                </div>
                <div className="space-y-3">
                    {CLASSES.map(cls => (
                        <Card key={cls.id} className="flex items-center justify-between p-3">
                            <div className="flex gap-3 items-center">
                                <div className="bg-zinc-100 p-2 rounded-lg font-bold text-zinc-700 text-xs text-center w-12">
                                    {cls.time}
                                </div>
                                <div>
                                    <h4 className="font-semibold text-sm text-zinc-900">{cls.name}</h4>
                                    <p className="text-xs text-zinc-500">{cls.instructor} • {cls.type}</p>
                                </div>
                            </div>
                            <Badge>{cls.students} alunos</Badge>
                        </Card>
                    ))}
                </div>
            </div>
        </PageTransition>
    );
};

export const StudentDashboard = () => {
    const student = STUDENTS[0]; // Mock logged in user
    const percentage = Math.min((student.classes / student.nextGrad) * 100, 100);

    return (
        <PageTransition className="p-4 space-y-6 pb-24">
             {/* Header */}
             <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-xl font-bold text-zinc-900">Olá, {student.name.split(' ')[0]}!</h1>
                    <p className="text-zinc-500 text-xs">Vamos treinar hoje?</p>
                </div>
                <div className="w-10 h-10 bg-zinc-200 rounded-full overflow-hidden border-2 border-white shadow-sm">
                    <img src={`https://i.pravatar.cc/150?u=${student.id}`} alt="User" />
                </div>
            </div>

            {/* Hero Belt */}
            <div className="space-y-2">
                <div className="flex justify-between items-end px-1">
                     <span className="text-xs font-semibold text-zinc-500 uppercase">Faixa Atual</span>
                     <span className="text-xs font-semibold text-zinc-900">{student.stripes} Graus</span>
                </div>
                <Belt color={student.rank as any} stripes={student.stripes} size="lg" />
            </div>

            {/* Progress */}
            <Card className="p-4 space-y-4">
                <div className="flex justify-between items-center">
                    <h3 className="font-semibold text-sm">Próxima Graduação</h3>
                    <span className="text-xs font-bold text-zinc-400">{student.classes}/{student.nextGrad} aulas</span>
                </div>
                
                <div className="w-full bg-zinc-100 rounded-full h-3 overflow-hidden">
                    <div className="h-full bg-zinc-900 rounded-full transition-all duration-1000" style={{ width: `${percentage}%` }} />
                </div>

                <div className="flex gap-4 mt-2">
                    <div className="flex-1 bg-zinc-50 rounded-xl p-3 flex flex-col items-center border border-zinc-100">
                        <span className="text-2xl font-bold text-zinc-900">{student.classes}</span>
                        <span className="text-[10px] text-zinc-500 uppercase tracking-wide">Aulas Feitas</span>
                    </div>
                    <div className="flex-1 bg-zinc-50 rounded-xl p-3 flex flex-col items-center border border-zinc-100">
                        <span className="text-2xl font-bold text-zinc-900">{Math.max(student.nextGrad - student.classes, 0)}</span>
                        <span className="text-[10px] text-zinc-500 uppercase tracking-wide">Faltam</span>
                    </div>
                </div>
            </Card>

            {/* Next Classes */}
            <div>
                 <h3 className="text-sm font-semibold text-zinc-900 mb-3">Próximos Treinos</h3>
                 <div className="space-y-3">
                    <Card className="flex gap-4 items-center">
                         <div className="bg-zinc-950 text-white rounded-lg p-3 flex flex-col items-center justify-center w-14">
                             <span className="text-xs font-medium">HOJE</span>
                             <span className="font-bold">18:30</span>
                         </div>
                         <div>
                             <h4 className="font-bold text-sm">Jiu-Jitsu Avançado</h4>
                             <p className="text-xs text-zinc-500">Mestre Rickson</p>
                         </div>
                         <Button variant="outline" className="ml-auto h-8 px-3 text-xs">Check-in</Button>
                    </Card>
                    <Card className="flex gap-4 items-center opacity-60">
                         <div className="bg-zinc-100 text-zinc-500 rounded-lg p-3 flex flex-col items-center justify-center w-14">
                             <span className="text-xs font-medium">AMANHÃ</span>
                             <span className="font-bold">07:00</span>
                         </div>
                         <div>
                             <h4 className="font-bold text-sm">Drills & Posições</h4>
                             <p className="text-xs text-zinc-500">Prof. Galvão</p>
                         </div>
                    </Card>
                 </div>
            </div>
        </PageTransition>
    )
}
