use Mix.Config

config :dup, results: :dup_results
config :dup, pathfinder: :dup_pathfinder
config :dup, worker_supervisor: :dup_worker_sup
config :dup, worker: :dup_worker
config :dup, gatherer: :dup_gatherer

config :vasuki, dirwalker: :dup_dirwalker
config :vasuki, mucket: :dup_data_mucket
