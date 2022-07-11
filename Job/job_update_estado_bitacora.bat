echo off
start sqlcmd -S sql17.ide-solution.com -d DB_virgendelcarmen -U sa -P IdeSolution*19 -i E:\repositorio-remoto-web\data\consultaJob.sql -o E:\repositorio-remoto-web\data\salidasql.txt -C
exit
