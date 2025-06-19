INSERT INTO public.components (index, name)
VALUES ('death_rate_taipei_by_cause_and_year', '死因別死亡率總覽')
ON CONFLICT (index) DO NOTHING; 

SELECT * FROM public.components
WHERE index = 'death_rate_taipei_by_cause_and_year'; 