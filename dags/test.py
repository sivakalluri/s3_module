import airflow
from airflow.models import DAG
from airflow.utils.dates import days_ago
from datetime import datetime, timedelta
import time
from airflow.operators.python_operator import PythonOperator
​
default_args = {
    'owner': 'hello_world',
    'depends_on_past': False,
    'start_date': datetime(2022, 7, 27),
    'catchup':False
    }
​
def timer():
    time.sleep(1800)
​
with DAG(dag_id='timer', default_args=default_args, schedule_interval=None) as dag:
    timer = PythonOperator(
    task_id = 'timer',
    provide_context = True,
    python_callable = timer)
