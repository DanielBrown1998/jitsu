import React, { useState } from 'react';
import { AnimatePresence } from 'motion/react';
import { AuthScreen } from '@/app/components/AuthScreens';
import { AdminDashboard, StudentDashboard } from '@/app/components/Dashboards';
import { StudentList, StudentProfile, StudentForm } from '@/app/components/StudentScreens';
import { AttendanceSelect, AttendanceRegister, AttendanceSuccess, GraduationList, GraduationPromote, GraduationSuccess } from '@/app/components/ActionScreens';
import { ReportsDashboard, ClassReport } from '@/app/components/ReportScreens';
import { Layout, Menu, X, Home, Users, LogOut } from 'lucide-react';

const MobileLayout = ({ children, activeScreen, navigateTo, userRole, onLogout }: any) => {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <div className="min-h-screen bg-zinc-200 flex items-center justify-center font-sans antialiased text-zinc-900">
      <div className="w-full max-w-md h-[100dvh] bg-zinc-50 shadow-2xl overflow-hidden relative flex flex-col sm:rounded-[2.5rem] sm:h-[90vh] sm:border-[8px] sm:border-zinc-900">
        
        {/* Mobile Header (Only show if logged in) */}
        {activeScreen !== 'auth' && (
            <div className="absolute top-4 right-4 z-50">
                <button 
                    onClick={() => setMenuOpen(true)} 
                    className="w-10 h-10 bg-white/80 backdrop-blur rounded-full shadow-sm flex items-center justify-center text-zinc-900 border border-zinc-200"
                >
                    <Menu size={20} />
                </button>
            </div>
        )}

        {/* Menu Drawer */}
        <AnimatePresence>
            {menuOpen && (
                <>
                    <div className="absolute inset-0 bg-black/50 z-50 backdrop-blur-sm" onClick={() => setMenuOpen(false)} />
                    <div className="absolute top-0 right-0 w-64 h-full bg-zinc-950 z-[60] p-6 shadow-2xl flex flex-col animate-in slide-in-from-right duration-300">
                        <div className="flex justify-end mb-8">
                            <button onClick={() => setMenuOpen(false)} className="text-white"><X /></button>
                        </div>
                        
                        <div className="flex items-center gap-3 mb-8 pb-8 border-b border-zinc-800">
                            <div className="w-12 h-12 rounded-full bg-zinc-800 flex items-center justify-center text-white font-bold">
                                {userRole === 'admin' ? 'AD' : 'AL'}
                            </div>
                            <div>
                                <h3 className="text-white font-bold">{userRole === 'admin' ? 'Admin User' : 'Aluno Demo'}</h3>
                                <p className="text-zinc-500 text-xs uppercase">{userRole === 'admin' ? 'Professor' : 'Faixa Branca'}</p>
                            </div>
                        </div>

                        <nav className="flex-1 space-y-2">
                            <button onClick={() => {navigateTo(userRole === 'admin' ? 'admin_home' : 'student_home'); setMenuOpen(false)}} className="w-full text-left text-zinc-300 hover:text-white py-3 flex gap-3 font-medium"><Home size={20} /> Início</button>
                            {userRole === 'admin' && (
                                <button onClick={() => {navigateTo('students_list'); setMenuOpen(false)}} className="w-full text-left text-zinc-300 hover:text-white py-3 flex gap-3 font-medium"><Users size={20} /> Alunos</button>
                            )}
                        </nav>

                        <button onClick={onLogout} className="text-red-500 flex gap-3 py-4 font-medium"><LogOut size={20} /> Sair</button>
                    </div>
                </>
            )}
        </AnimatePresence>
        
        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto overflow-x-hidden relative bg-zinc-50">
            {children}
        </main>

      </div>
    </div>
  );
};

export default function App() {
  const [activeScreen, setActiveScreen] = useState('auth');
  const [userRole, setUserRole] = useState<'admin' | 'student'>('admin');

  const handleLogin = (role: 'admin' | 'student') => {
      setUserRole(role);
      setActiveScreen(role === 'admin' ? 'admin_home' : 'student_home');
  };

  const renderScreen = () => {
      switch(activeScreen) {
          case 'auth': return <AuthScreen onLogin={handleLogin} />;
          
          // Dashboards
          case 'admin_home': return <AdminDashboard navigateTo={setActiveScreen} />;
          case 'student_home': return <StudentDashboard />;
          
          // Students
          case 'students_list': return <StudentList navigateTo={setActiveScreen} />;
          case 'students_profile': return <StudentProfile navigateTo={setActiveScreen} />;
          case 'students_new': return <StudentForm navigateTo={setActiveScreen} />;
          case 'students_edit': return <StudentForm navigateTo={setActiveScreen} />; // Reuse form for now
          case 'students_history': return <StudentProfile navigateTo={setActiveScreen} />; // Simplified flow

          // Attendance
          case 'attendance_select': return <AttendanceSelect navigateTo={setActiveScreen} />;
          case 'attendance_register': return <AttendanceRegister navigateTo={setActiveScreen} />;
          case 'attendance_success': return <AttendanceSuccess navigateTo={setActiveScreen} />;

          // Graduation
          case 'graduation_list': return <GraduationList navigateTo={setActiveScreen} />;
          case 'graduation_promote': return <GraduationPromote navigateTo={setActiveScreen} />;
          case 'graduation_success': return <GraduationSuccess navigateTo={setActiveScreen} />;

          // Reports
          case 'reports': return <ReportsDashboard navigateTo={setActiveScreen} />;
          case 'reports_class': return <ClassReport navigateTo={setActiveScreen} />;

          default: return <div className="p-10">Tela não encontrada: {activeScreen}</div>;
      }
  };

  return (
    <MobileLayout 
        activeScreen={activeScreen} 
        navigateTo={setActiveScreen} 
        userRole={userRole}
        onLogout={() => setActiveScreen('auth')}
    >
      <AnimatePresence mode="wait">
        <div key={activeScreen} className="h-full">
            {renderScreen()}
        </div>
      </AnimatePresence>
    </MobileLayout>
  );
}
