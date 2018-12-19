json.extract! enquiry, :id, :subject, :email, :description, :created_at, :updated_at
json.url enquiry_url(enquiry, format: :json)
