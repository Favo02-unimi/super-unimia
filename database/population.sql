SET search_path TO unimia;

CALL new_segretario('seg', 'retario', '8Caratteri!');

CALL new_corso_di_laurea('L-31', 'Triennale', 'Informatica', 'Pura, non ingegneri');
CALL new_corso_di_laurea('CU-01', 'Magistrale a ciclo unico', 'Medicina', 'Curatemi da PHP');

CALL new_studente('stu', 'dente', '8Caratteri!', 'L-31');
CALL new_docente('doc', 'ente', '8Caratteri!');

