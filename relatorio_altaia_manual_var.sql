ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';



-- ANÁLISES TEMPORAIS

    select * from <schema>.<table>
    where 1=1
    and NUMOPEDW0 = 1
    and dia between trunc(sysdate-30) and trunc(sysdate-1) --PERIODO DE TEMPO
    and hora in (2,3) --HOPS ESPECÍFICOS
    and altname  in ('cm_gps') --TABELAS A SEREM ANALISADAS
    and fonte='DBN0' --FONTE DAS TABELAS
    order by altname, dia;
    


--TABELAS VINDO COM VARIAÇÕES VIVO DBN0 (APENAS CM)

    select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.numopedw0, tab1.dia, tab1.soma, tab1.median, tab1.variacao from (
    select fonte, altname, dia, numopedw0, soma, median, NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao from 
    (
    select fonte,altname,dia ,numopedw0, sum(valor) soma, median(SUM(valor)) OVER (PARTITION BY fonte, altname, numopedw0) median
    from <schema>.<table>
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0, dia
    ) 
    where dia = trunc(sysdate-1) --DATA DA ANALISE
    and fonte = 'DBN0'
    and altname like 'cm%'
    and numopedw0 = 3
    and soma != 0
    and (NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) < -10 or NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) > 10)
    order by altname, dia) tab1
    left join <schema>.<table> tab2
    on tab1.altname = tab2.altname
    order by tab1.altname, tab1.variacao desc;
    
    
    
--TABELAS VINDO COM VARIAÇÕES VIVO DBN0 (SEM CM)

    select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.numopedw0, tab1.dia, tab1.valor, tab1.median, tab1.variacao from (
    select fonte, altname, numopedw0, dia, hora, valor, median, NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao from 
    (
    select fonte,altname, dia ,numopedw0, hora, valor, median(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname, dia, numopedw0, hora, valor
    ) 
    where dia = trunc(sysdate-1) --DATA DA ANALISE
    and fonte = 'DBN0'
    and altname not like 'cm%'
    and numopedw0 = 3
    and valor != 0
    and (NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) < -10 or NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) > 10)
    order by altname, dia) tab1
    left join <schema>.<table> tab2
    on tab1.altname = tab2.altname
    order by tab1.altname, tab1.variacao desc;




--TABELAS VINDO COM VARIAÇÕES TIM DBN0 (APENAS CM)

    select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.numopedw0, tab1.dia, tab1.soma, tab1.median, tab1.variacao from (
    select fonte, altname, dia, numopedw0, soma, median, NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao from 
    (
    select fonte,altname,dia ,numopedw0, sum(valor) soma, median(SUM(valor)) OVER (PARTITION BY fonte, altname, numopedw0) median
    from <schema>.<table>
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0, dia
    ) 
    where dia = trunc(sysdate-1) --DATA DA ANALISE
    and fonte = 'DBN0'
    and altname like 'cm%'
    and numopedw0 = 1
    and soma != 0
    and (NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) < -10 or NVL((NVL(soma - median, 0) / NULLIF(median, 0)) * 100, 0) > 10)
    order by altname, dia) tab1
    left join <schema>.<table> tab2
    on tab1.altname = tab2.altname
    order by tab1.altname, tab1.variacao desc;
    
    
    
--TABELAS VINDO COM VARIAÇÕES TIM DBN0 (SEM CM)

    select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.numopedw0, tab1.dia, tab1.valor, tab1.median, tab1.variacao from (
    select fonte, altname, numopedw0, dia, hora, valor, median, NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao from 
    (
    select fonte,altname, dia ,numopedw0, hora, valor, median(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname, dia, numopedw0, hora, valor
    ) 
    where dia = trunc(sysdate-1) --DATA DA ANALISE
    and fonte = 'DBN0'
    and altname not like 'cm%'
    and numopedw0 = 1
    and valor != 0
    and (NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) < -10 or NVL((NVL(valor - median, 0) / NULLIF(median, 0)) * 100, 0) > 10)
    order by altname, dia) tab1
    left join <schema>.<table> tab2
    on tab1.altname = tab2.altname
    order by tab1.altname, tab1.variacao desc;
    
    
    
    
---------------------------------------------------------------------------------------------------------


--TABELAS VINDO COM VARIAÇÃO TIM DBN1
select tab1.fonte,tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.hora, tab1.valor, tab1.median, tab1.variacao
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.hora,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte,altname,numopedw0,hora,median(NULLIF(valor, 0)) median
    from <schema>.<table>
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0,hora) avg
    where a.fonte = avg.fonte
    and a.altname = avg.altname
    and a.numopedw0 = avg.numopedw0
    and a.hora = avg.hora
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE 
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) not like -100
     and (NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) < -10 or NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) > 10)
    and a.valor != 0
    and a.NUMOPEDW0 = 1
    and a.FONTE='DBN1'
    order by a.fonte,a.altname,a.numopedw0,a.dia,a.hora) tab1
left join <schema>.<table> tab2
on tab1.altname = tab2.altname
order by altname, hora, variacao;