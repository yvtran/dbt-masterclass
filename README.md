# dbt-masterclass
dbt for Analytics Engineer masterclass

## Introduction
Ce répertoire contient un tutorial introductif à l'usage de <a href='https://www.getdbt.com/'>dbt</a>. Il contient une série d'exercices pour s'initier à l'outil à faire à partir de la branche `main`.
Pour cela, il est conseillé d'utiliser:
* <a href='https://www.getdbt.com/product/dbt-cloud'>dbt Cloud</a>
* Avoir accès au projet GCP dédié et l'environnement BigQuery :blush:

## Les données sources utilisées
Les données sont issues de dbt-Labs qui présentent les clients et commmandes d'un commerce fictif: `jaffle_shop`. Nous allons simplement exploiter les données de :
- commandes (table orders)
- clients (table customers)

## Exercices

### Question 0 - Tester sa connexion :bridge_at_night:

Pour tester sa connexion, lancez la commande suivante :
```shell
dbt debug
```
Le tag `success` devrait apparaitre en vert.

Puis lancez la commande suivante :
```shell
dbt run
```
Constatez que les modèles sont créés sur BigQuery.

> **_NOTE:_**  Lors de la création d'un projet data, dbt suggère de structurer son projet data en séparant les modèles en 3 niveaux:
> * <u>staging</u>: preprocessing des données sources (renommage, filtrage simple...)
> * <u>intermediate</u>: exploitation de vos modèles en staging pour créer une couche logique en vue de préparer sa donnée à l'exposition (jointure, aggrégation, intégration de vos besoins...)
> * <u>marts</u>: couche finale de transformation des données pour l'exposition
>
>   Nous aurons des modèles nommées stg_customers, int_customers, orders afin de se répérer facilement.

### Question 1 - Créer une vue (staging) :construction_worker:

Ajoutez une nouvelle **source** pour lire la table `avisia-training-dbt.dbt_demo.orders` dans le fichier `models/staging/_schema.yml`.

Créez un nouveau fichier `models/staging/stg_orders.sql` et templatisez la requête suivante pour créer une vue:

```sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from `avisia-training-dbt.dbt_demo.orders`
```

Lancez `dbt run -s stg_orders` pour exécuter la création de la vue.

> **_NOTE (Bonus):_**  Pour savoir comment dbt distingue le mode de création d'un modèle (table, vue...), examinez le fichier `dbt_project.yml`.

### Question 2 - Création d'une table :muscle:

Créez un dossier `models/marts/` et y créer un fichier `models/marts/orders_history.sql` en templatisant la requête suivante :

```sql
with
orders as (
  select * from `avisia-training-dbt.dbt_xxx.stg_orders`
),

customers as (
  select * from `avisia-training-dbt.dbt_xxx.stg_customers`
),

final as (
  select
    customer_id,
    order_id,
    first_name as customer_first_name,
    last_name as customer_last_name,
    status,
  from orders
  left join
    customers
  using (customer_id)
)

select * from final
```

Lancez `dbt run -s orders_history` pour exécuter la création de la vue.

### Question 3 - Générer la documentation :green_book:
Lancez la commande :
```shell
dbt docs generate
```

Et cliquez sur l'icône en forme de livre: <br>
![image](https://github.com/yvtran/dbt-masterclass/assets/167016967/f989ab01-2f8e-4b1b-8d73-488da4d11474)

Arrivez-vous à retrouver la vue d'ensemble du DAG ?

### Question 4 - Installer un package :rocket:

Installez le package `dbt-utils` en suivant les instructions du lien officiel: https://hub.getdbt.com/dbt-labs/dbt_utils/latest/ 

### Question 5 - Mettre en place un test d'unicité à l'aide de dbt_utils :sunglasses:

Mettez en place un test d'unicité sur la combinaison de colonnes `customer_id` et `order_id` de la table `orders_history` dans le fichier `models/marts/_schema.yml`.

<u>Indice</u>: https://docs.getdbt.com/faqs/Tests/uniqueness-two-columns#3-use-the-dbt_utilsunique_combination_of_columns-test

(Le champ `order_id` aurait pu suffire mais c'est pour le bien de l'exercice ;) )

Puis lancez `dbt test` et constatez que les tests passent ! :white_check_mark:
