import React, { useState } from 'react';
import { PageTransition, Card, Input, Button, Belt, Badge, cn } from './JitsuDesignSystem';
import { Search, Filter, Plus, ChevronLeft, MoreVertical, Check, X, Camera } from 'lucide-react';

const STUDENTS_MOCK = [
    { id: 1, name: 'Carlos Silva', rank: 'white', stripes: 3, status: 'active' },
    { id: 2, name: 'Mariana Costa', rank: 'blue', stripes: 1, status: 'active' },
    { id: 3, name: 'Pedro Santos', rank: 'white', stripes: 0, status: 'inactive' },
    { id: 4, name: 'Ana Oliveira', rank: 'purple', stripes: 2, status: 'active' },
    { id: 5, name: 'Lucas Ferreira', rank: 'white', stripes: 4, status: 'active' },
    { id: 6, name: 'Roberto Souza', rank: 'brown', stripes: 0, status: 'active' },
    { id: 7, name: 'Julia Martins', rank: 'black', stripes: 1, status: 'active' },
];

export const StudentList = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50">
            {/* Header */}
            <div className="bg-white px-4 py-4 border-b border-zinc-100 sticky top-0 z-10">
                <div className="flex justify-between items-center mb-4">
                    <h1 className="text-xl font-bold text-zinc-900">Alunos</h1>
                    <Button onClick={() => navigateTo('students_new')} variant="primary" className="h-9 px-3 text-xs"><Plus size={16} /> Novo</Button>
                </div>
                <div className="flex gap-2">
                     <div className="flex-1">
                        <Input icon={<Search size={16} />} placeholder="Buscar aluno..." className="h-10 text-sm" />
                     </div>
                     <Button variant="outline" className="h-10 w-10 px-0 flex items-center justify-center border-zinc-200 bg-white"><Filter size={18} /></Button>
                </div>
            </div>

            {/* List */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3 pb-24">
                {STUDENTS_MOCK.map((student) => (
                    <div onClick={() => navigateTo('students_profile')} key={student.id} className="bg-white p-3 rounded-xl border border-zinc-100 shadow-sm flex items-center gap-3 active:scale-[0.99] transition-transform">
                        <div className="relative">
                            <img 
                                src={`https://i.pravatar.cc/150?u=${student.id}`} 
                                className={cn("w-12 h-12 rounded-full object-cover", student.status === 'inactive' && "grayscale opacity-50")}
                                alt={student.name} 
                            />
                            {student.status === 'inactive' && <div className="absolute -bottom-1 -right-1 bg-zinc-500 text-white text-[8px] px-1 rounded">INATIVO</div>}
                        </div>
                        
                        <div className="flex-1">
                            <h3 className={cn("font-semibold text-sm", student.status === 'inactive' && "text-zinc-400")}>{student.name}</h3>
                            <div className="mt-1 w-24">
                                <Belt color={student.rank as any} stripes={student.stripes} size="sm" />
                            </div>
                        </div>

                        <button className="text-zinc-300 p-2"><MoreVertical size={16} /></button>
                    </div>
                ))}
            </div>
        </PageTransition>
    )
}

export const StudentProfile = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
             <div className="relative bg-zinc-900 text-white pt-8 pb-16 px-6 rounded-b-[2.5rem] shadow-xl overflow-hidden">
                <div className="absolute top-0 left-0 w-full h-full opacity-10 bg-[url('https://www.transparenttextures.com/patterns/fabric-of-squares.png')]"></div>
                
                <div className="relative z-10 flex flex-col items-center">
                    <div className="flex w-full justify-between mb-4">
                        <button onClick={() => navigateTo('students_list')} className="p-2 bg-white/10 rounded-full hover:bg-white/20"><ChevronLeft size={20} /></button>
                        <button onClick={() => navigateTo('students_edit')} className="p-2 bg-white/10 rounded-full hover:bg-white/20 font-xs font-bold px-4 text-xs">Editar</button>
                    </div>

                    <div className="w-24 h-24 rounded-full border-4 border-white shadow-lg overflow-hidden mb-4">
                        <img src="https://i.pravatar.cc/150?u=1" className="w-full h-full object-cover" alt="Profile" />
                    </div>
                    <h1 className="text-2xl font-bold">Carlos Silva</h1>
                    <p className="text-zinc-400 text-sm mb-6">Iniciado em Jan 2023</p>

                    <Belt color="white" stripes={3} size="lg" className="shadow-2xl max-w-xs mx-auto" />
                </div>
             </div>

             <div className="px-6 -mt-8 relative z-20 space-y-6">
                {/* Stats */}
                <Card className="flex justify-around p-4 shadow-lg">
                    <div className="text-center">
                        <div className="text-xl font-bold text-zinc-900">24</div>
                        <div className="text-[10px] uppercase text-zinc-500 font-bold tracking-wider">Aulas</div>
                    </div>
                    <div className="w-px bg-zinc-100" />
                    <div className="text-center">
                        <div className="text-xl font-bold text-green-600">92%</div>
                        <div className="text-[10px] uppercase text-zinc-500 font-bold tracking-wider">Presença</div>
                    </div>
                    <div className="w-px bg-zinc-100" />
                     <div className="text-center">
                        <div className="text-xl font-bold text-zinc-900">30</div>
                        <div className="text-[10px] uppercase text-zinc-500 font-bold tracking-wider">Meta</div>
                    </div>
                </Card>

                {/* Info Sections */}
                <div className="space-y-4">
                    <h3 className="font-bold text-zinc-900 text-sm">Dados Pessoais</h3>
                    <div className="bg-white rounded-2xl p-4 border border-zinc-100 space-y-3 text-sm">
                        <div className="flex justify-between border-b border-zinc-50 pb-2">
                            <span className="text-zinc-500">Email</span>
                            <span className="font-medium">carlos.silva@email.com</span>
                        </div>
                         <div className="flex justify-between border-b border-zinc-50 pb-2">
                            <span className="text-zinc-500">Telefone</span>
                            <span className="font-medium">(11) 99999-9999</span>
                        </div>
                         <div className="flex justify-between">
                            <span className="text-zinc-500">Nascimento</span>
                            <span className="font-medium">12/05/1995</span>
                        </div>
                    </div>

                    <h3 className="font-bold text-zinc-900 text-sm flex justify-between items-center">
                        Histórico 
                        <span onClick={() => navigateTo('students_history')} className="text-xs text-blue-600 font-normal cursor-pointer">Ver completo</span>
                    </h3>
                    <div className="space-y-3">
                         <div className="flex gap-4">
                             <div className="flex flex-col items-center">
                                 <div className="w-2 h-2 rounded-full bg-zinc-300" />
                                 <div className="w-0.5 h-full bg-zinc-200" />
                             </div>
                             <div className="pb-4">
                                 <p className="text-xs text-zinc-400 font-medium">12 Out 2023</p>
                                 <p className="text-sm font-semibold text-zinc-800">Graduado para 3º Grau</p>
                                 <p className="text-xs text-zinc-500 mt-1">Evolução constante na guarda.</p>
                             </div>
                         </div>
                    </div>
                </div>
             </div>
        </PageTransition>
    )
}

export const StudentForm = ({ navigateTo }: { navigateTo: (screen: string) => void }) => {
    return (
        <PageTransition className="flex flex-col h-full bg-zinc-50 pb-24">
            <div className="bg-white px-4 py-4 border-b border-zinc-100 flex items-center gap-4 sticky top-0 z-10">
                <button onClick={() => navigateTo('students_list')}><ChevronLeft /></button>
                <h1 className="text-lg font-bold">Novo Aluno</h1>
            </div>

            <div className="p-4 space-y-6">
                 {/* Photo Upload */}
                 <div className="flex flex-col items-center gap-3">
                     <div className="w-24 h-24 rounded-full bg-zinc-100 border-2 border-dashed border-zinc-300 flex items-center justify-center text-zinc-400">
                         <Camera size={24} />
                     </div>
                     <span className="text-xs text-blue-600 font-medium">Alterar Foto</span>
                 </div>

                 {/* Form */}
                 <div className="space-y-4">
                     <h3 className="text-xs font-bold text-zinc-400 uppercase tracking-wider">Dados Básicos</h3>
                     <Input label="Nome Completo" placeholder="Ex: João da Silva" />
                     <Input label="CPF" placeholder="000.000.000-00" />
                     <div className="grid grid-cols-2 gap-4">
                        <Input label="Data Nascimento" type="date" />
                        <Input label="Telefone" placeholder="(00) 00000-0000" />
                     </div>
                     <Input label="Email" type="email" placeholder="joao@email.com" />

                     <h3 className="text-xs font-bold text-zinc-400 uppercase tracking-wider mt-6">Acadêmico</h3>
                     <div className="space-y-2">
                         <label className="text-sm font-medium text-zinc-700">Faixa Inicial</label>
                         <div className="grid grid-cols-5 gap-2">
                             {['white', 'blue', 'purple', 'brown', 'black'].map(c => (
                                 <button key={c} className={cn("h-8 rounded border transition-all", c === 'white' ? "bg-white border-zinc-300" : `bg-${c === 'black' ? 'zinc-900' : c === 'brown' ? 'amber-900' : c === 'purple' ? 'purple-700' : 'blue-600'}`)} />
                             ))}
                         </div>
                     </div>
                     
                     <div className="space-y-2">
                         <label className="text-sm font-medium text-zinc-700">Turmas</label>
                         <div className="flex flex-wrap gap-2">
                             <Badge variant="outline" className="py-2 px-3 border-zinc-300">Jiu-Jitsu Manhã</Badge>
                             <Badge variant="success" className="py-2 px-3">Jiu-Jitsu Noite</Badge>
                             <Badge variant="outline" className="py-2 px-3 border-zinc-300">No-Gi</Badge>
                         </div>
                     </div>
                 </div>
            </div>

            <div className="p-4 bg-white border-t border-zinc-100 fixed bottom-0 w-full max-w-md">
                <Button onClick={() => navigateTo('students_list')} className="w-full">Cadastrar Aluno</Button>
            </div>
        </PageTransition>
    )
}
