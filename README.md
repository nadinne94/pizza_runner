# Pizza Runner
## Desafio SQL - 2º Estudo de caso
<p align="justify">
  Dando continuidade ao desafio de 8 estudos de casos em 8 semanas, apresento o desenvolvimento do segundo estudo de caso, no qual são fornecidos dados sobre uma nova pizzaria, cujas entregas são realizadas por corredores. O gerenciador de Banco de Dandos escolhido para realização das consultas foi o SQL Server.
  O seguinte diagrama de entidade-relacionamento do seu banco de dados é fornecido, mas será necessário realizar o tratamento dos dados antes de analisar os dados que possam melhor orientar os  corredores e otimizar as operações do Pizza Runner.<br>
   <img src="diagrama_entidades.png" height=500px> <br>
</p>

## Solução
<p align="justify">
  Antes de dar início as consultas é importante fazer uma inspeção dos dados para verificar se existe algum tipo de inconsistência que ocasionaria erro ao tentar recuperas as informações no banco de dados. Neste caso foram detectadas incoerências nos dados das tabelas customer_orders e runner_orders, portanto, o primeiro passo será a limpeza e tratamento dos dados.</p>

### Tabela <i>customer_orders</i>
  <img src="imagens/table_customer_orders.png">
<p align="justify">
  As células em que os clientes não solicitam exclusões ou extras são representadas de maneira inconsistente. Elas podem ter o tipo de dados Nulo (ou seja, [NULL]), null como uma string (ou seja, [null]) ou podem ser deixadas em branco.Portanto, queremos adotar um único método de representação para as células que não possuem exclusões ou extras. Agora, como essas colunas são do tipo text e contêm strings, faz sentido representar uma célula sem exclusão ou extra como uma string vazia. 
</p>
  <img src="imagens/create_temp_customer_order.png">
<p align="justify">
  A ideia é criar uma tabela temporária, temp_customer_orders, que será uma cópia da nossa tabela original, customer_orders. A limpeza ou transformação dos dados será feita na tabela temporária, mantendo nossa tabela original intocada, para que tenhamos uma fonte de backup, caso seja necessário.
</p>
   <img src="imagens/select_temp_customer_order.png">
   
### Tabela <i>runner_orders</i>
   <img src="imagens/table_runner_orders.png">
<p align="justify">
  Observa-se que as colunas pickup_time, distance e duration, portanto precisamos substituir os valores nulos (que estão escritos como uma string) pelo tipo de dado [null]. Além disso, devemos remover os 'km', 'minute', 'minutes' e 'mins' das colunas distance e duration. A coluna cancellation tem os mesmos problemas das colunas exclusions e extras em customer_orders. Portanto, aplicaremos a mesma lógica que aplicamos a essas colunas à coluna de cancelamento. 
</p>
  <img src="">
<p align="justify">
  Aplicada as alterações necessárias temos a tabela temp_runner_orders:
</p>
   <img src="">

* **[Desafio](https://8weeksqlchallenge.com/case-study-2/)**


## Contato
<div>
  <a href="https://www.linkedin.com/in/nadinne-cavalcante/" target="_blank"><img src="https://img.shields.io/badge/-LinkedIn-%230077B5?style=for-the-badge&logo=linkedin&logoColor=white" target="_blank"></a>
  <a href="mailto:nadinnecavalcantesilva@gmail.com"><img src="https://img.shields.io/badge/-Gmail-%23333?style=for-the-badge&logo=gmail&logoColor=white" target="_blank"></a>
</div>
