json.extract! transaction, :id, :source, :destination, :value, :state, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
