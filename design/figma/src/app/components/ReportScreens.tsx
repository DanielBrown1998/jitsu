import React from 'react';
import { PageTransition, Card, Button, Belt, Badge, cn } from './JitsuDesignSystem';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';
import { ChevronLeft, Download, Filter } from 'lucide-react';

const DATA_ATTENDANCE = [
  { name: 'Jan', total: 65 },
  { name: 'Fev', total: 72 },
  { name: 'Mar', total: 85 },
  { name: 'Abr', total: 78 },
  { name: 'Mai', total: 90 },
  { name: 'Jun', total: 95 },
];

const DATA_RANK = [
    { name: 'Branca', value: 45, fill: '#d4d4d8' },
    { name: 'Azul', value: 25, fill: '#2563eb' },
    { name: 'Roxa', value: 15, fill: '#7e22ce' },
    { name: 'Marrom', value: 8, fill: '#92400e' },
    { name: 'Preta', value: 4, fill: '#000000' },
];

export const ReportsDashboard = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('admin_home')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Relatórios</h1>
            </div>

            <div className="p-4 space-y-6">
                {/* Monthly Attendance Chart */}
                <Card className="p-4">
                    <div className="flex justify-between items-center mb-4">
                        <h3 className="font-bold text-zinc-900">Frequência Mensal</h3>
                        <Button variant="ghost" className="h-8 px-2"><Filter size={14} /></Button>
                    </div>
                    <div className="h-48 w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <BarChart data={DATA_ATTENDANCE}>
                                <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f4f4f5" />
                                <XAxis dataKey="name" axisLine={false} tickLine={false} tick={{fontSize: 10}} />
                                <YAxis axisLine={false} tickLine={false} tick={{fontSize: 10}} />
                                <Tooltip cursor={{fill: '#f4f4f5'}} contentStyle={{borderRadius: '8px', border: 'none', boxShadow: '0 4px 12px rgba(0,0,0,0.1)'}} />
                                <Bar dataKey="total" fill="#18181b" radius={[4, 4, 0, 0]} />
                            </BarChart>
                        </ResponsiveContainer>
                    </div>
                </Card>

                 {/* Students by Rank */}
                 <Card className="p-4">
                    <h3 className="font-bold text-zinc-900 mb-4">Alunos por Faixa</h3>
                    <div className="space-y-3">
                        {DATA_RANK.map((item) => (
                            <div key={item.name} className="flex items-center gap-3">
                                <span className="text-xs font-medium w-12">{item.name}</span>
                                <div className="flex-1 bg-zinc-100 h-2 rounded-full overflow-hidden">
                                    <div className="h-full rounded-full" style={{ width: `${(item.value / 50) * 100}%`, backgroundColor: item.fill }} />
                                </div>
                                <span className="text-xs text-zinc-500 font-bold w-6 text-right">{item.value}</span>
                            </div>
                        ))}
                    </div>
                </Card>

                {/* Class Performance Button */}
                <div onClick={() => navigateTo('reports_class')} className="bg-zinc-900 text-white p-4 rounded-xl flex justify-between items-center cursor-pointer active:scale-95 transition-transform">
                    <div>
                        <h3 className="font-bold">Relatório por Turma</h3>
                        <p className="text-xs text-zinc-400">Análise detalhada de performance</p>
                    </div>
                    <ChevronLeft className="rotate-180" />
                </div>
            </div>
        </PageTransition>
    )
}

export const ClassReport = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('reports')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Turma 07:00</h1>
            </div>

            <div className="p-4 space-y-4">
                 <div className="flex gap-2 mb-2">
                     <Badge variant="default" className="bg-zinc-200 text-zinc-900">Últimos 30 dias</Badge>
                     <Badge variant="outline">Fundamentals</Badge>
                 </div>

                 <div className="grid grid-cols-2 gap-3">
                     <Card className="p-3">
                         <div className="text-2xl font-bold">24</div>
                         <div className="text-[10px] text-zinc-500 uppercase">Total Aulas</div>
                     </Card>
                     <Card className="p-3">
                         <div className="text-2xl font-bold text-green-600">14.5</div>
                         <div className="text-[10px] text-zinc-500 uppercase">Média Alunos</div>
                     </Card>
                 </div>

                 <Card className="p-4">
                     <h3 className="font-bold text-sm mb-3">Mais Frequentes</h3>
                     {[1,2,3].map((i) => (
                         <div key={i} className="flex items-center justify-between py-2 border-b border-zinc-50 last:border-0">
                             <div className="flex items-center gap-2">
                                 <span className="font-bold text-zinc-300 w-4">{i}</span>
                                 <img src={`https://i.pravatar.cc/150?u=${i}`} className="w-8 h-8 rounded-full" />
                                 <span className="text-sm font-medium">Aluno Nome</span>
                             </div>
                             <span className="text-xs font-bold bg-zinc-100 px-2 py-1 rounded">22 aulas</span>
                         </div>
                     ))}
                 </Card>

                 <Button variant="outline" className="w-full gap-2">
                     <Download size={16} /> Exportar CSV
                 </Button>
            </div>
        </PageTransition>
    )
}
