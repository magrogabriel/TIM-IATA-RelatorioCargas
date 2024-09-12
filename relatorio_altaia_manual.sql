ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

-----------------------------------------------------------------------------------------

-- ANÁLISES TEMPORAIS

select * from <schema>.<table>
where 1=1
and NUMOPEDW0 = 1 --OPERADORA
and dia between trunc(sysdate-30) and trunc(sysdate-1) --PERIODO DE TEMPO
--and hora in (2) --HOPS ESPECÍFICOS
and altname  in ('CN_UGW_ResourceUnit') --TABELAS A SEREM ANALISADAS
and fonte='DBN1' --FONTE DAS TABELAS
order by altname, dia;

-------------------------------------------------------------------------

-- COMPARAÇÃO ENTRE DATAS DIFERENTES PARA ANALISAR ELEMENTOS FALTANTES/EXCEPCIONAIS

select distinct (tab1.altname), tab1.NUMOPEDW0 from (<schema>.<table> tab1
left join (select * from <schema>.<table>
where dia = trunc(sysdate-2)) tab2 --DATA MAIS DISTANTE
on tab1.altname = tab2.altname 
and tab1.NUMOPEDW0 = tab2.NUMOPEDW0
and tab1.HORA = tab2.HORA)
where tab1.dia = trunc(sysdate-1) --DATA MAIS ATUAL
and tab2.altname is null;


-----------------------------------------------------------------------------------


--TABELAS VINDO VAZIAS TIM DBN0 (SEM CM)

select tab1.fonte,tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.valor, tab1.hora
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.hora,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte,altname,numopedw0,hora,MEDIAN(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0,hora) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.hora = md.hora
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN0'
    and a.altname not like 'cm%'
    and a.NUMOPEDW0 = 1         
    order by a.fonte,a.altname,a.numopedw0,a.dia,a.hora) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname, hora;




--TABELAS VINDO VAZIAS TIM DBN0 (APENAS CM)
select tab1.fonte,tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.valor
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte,altname,numopedw0,MEDIAN(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN0'
    and a.altname like 'cm%'
    and a.NUMOPEDW0 = 1         
    order by a.fonte,a.altname,a.numopedw0,a.dia) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname;



--TABELAS VINDO VAZIAS VIVO DBN0 (SEM CM)

select tab1.fonte,tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.valor,  tab1.hora
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.hora,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte,altname,numopedw0,hora,MEDIAN(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0,hora) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.hora = md.hora
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN0'
    and a.altname not like 'cm%'
    and a.NUMOPEDW0 = 3         
    order by a.fonte,a.altname,a.numopedw0,a.dia,a.hora) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname, hora;



--TABELAS VINDO VAZIAS VIVO DBN0 (APENAS CM)
select tab1.fonte,tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor, tab1.valor
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte,altname,numopedw0,MEDIAN(valor) median
    from <schema>.<table> 
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN0'
    and a.altname like 'cm%'
    and a.NUMOPEDW0 = 3         
    order by a.fonte,a.altname,a.numopedw0,a.dia) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname;



-----------------------------------------------------------------------------------


--TABELAS VINDO VAZIAS TIM DBN1
select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor,  tab1.hora, tab1.valor
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.hora,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte, altname, numopedw0, hora, MEDIAN(NULLIF(valor, 0)) median
    from <schema>.<table>
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0,hora) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.hora = md.hora
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN1'
    and a.NUMOPEDW0 = 1
    order by a.fonte,a.altname,a.numopedw0,a.dia,a.hora) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname, hora;



--TABELAS VINDO VAZIAS VIVO DBN1
select  tab1.fonte, tab1.altname, tab2.domain, tab2.subdomain, tab2.vendor,  tab1.hora, tab1.valor
from (
    select a.fonte,a.altname,a.numopedw0,a.dia,a.hora,a.valor,median,NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) AS variacao
    from <schema>.<table> a,
    (select fonte, altname, numopedw0, hora, MEDIAN(NULLIF(valor, 0)) median
    from <schema>.<table>
    where dia between trunc(sysdate-40) and trunc(sysdate-1) --PERIODO A SER CONSIDERADO COMO PADRAO
    group by fonte,altname,numopedw0,hora) md
    where a.fonte = md.fonte
    and a.altname = md.altname
    and a.numopedw0 = md.numopedw0
    and a.hora = md.hora
    and a.dia = trunc(sysdate-1)  --DATA DA ANALISE
    and NVL((NVL(a.valor - median, 0) / NULLIF(median, 0)) * 100, 0) = -100
    and a.valor = 0
    and a.fonte='DBN1'
    and a.NUMOPEDW0 = 3
    order by a.fonte,a.altname,a.numopedw0,a.dia,a.hora) tab1
left join CTRL.D_DESC_TBL_ALT tab2
on tab1.altname = tab2.altname
order by altname, hora;


---------------------------------------------------------------------------------------
