# frozen_string_literal: true

require "rails_helper"

RSpec.describe V1::Events, type: :request do
  let(:base_url) { "/api/v1/events" }
  let(:event_type) { "business" }
  let(:title) { "Meeting with clients" }
  let(:description) { "Quarterly planning meeting" }
  let(:number_of_people) { 10 }
  let(:special_requests) { "Need projector and coffee" }

  let(:valid_event_params) do
    {
      title: title,
      description: description,
      event_type: event_type,
      number_of_people: number_of_people,
      special_requests: special_requests
    }
  end

  let(:invalid_event_params) do
    {
      title: "",
      event_type: "invalid_type"
    }
  end

  describe "GET /api/v1/events" do
    context "when there are events" do
      before do
        create(:event, title: "First event", event_type: "business")
        create(:event, title: "Second event", event_type: "birthday")
      end

      it "returns all events" do
        get base_url
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.first["title"]).to eq("First event")
        expect(json_response.second["title"]).to eq("Second event")
      end
    end

    context "when there are no events" do
      it "returns an empty array" do
        get base_url

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response).to be_empty
      end
    end
  end

  describe "GET /api/v1/events/:id" do
    context "when the event exists" do
      let(:event) { create(:event, valid_event_params) }

      it "returns the event" do
        get "#{base_url}/#{event.id}"

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response["id"]).to eq(event.id)
        expect(json_response["title"]).to eq(event.title)
        expect(json_response["description"]).to eq(event.description)
        expect(json_response["event_type"]).to eq(event.event_type)
        expect(json_response["number_of_people"]).to eq(event.number_of_people)
        expect(json_response["special_requests"]).to eq(event.special_requests)
      end
    end

    context "when the event does not exist" do
      it "returns a 404 error" do
        get "#{base_url}/999"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Event not found")
      end
    end
  end

  describe "POST /api/v1/events" do
    context "with valid parameters" do
      it "creates a new event" do
        expect do
          post base_url, params: valid_event_params
        end.to change(Event, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response["title"]).to eq(title)
        expect(json_response["description"]).to eq(description)
        expect(json_response["event_type"]).to eq(event_type)
        expect(json_response["number_of_people"]).to eq(number_of_people)
        expect(json_response["special_requests"]).to eq(special_requests)
      end
    end

    context "with invalid parameters" do
      it "does not create an event and returns errors" do
        expect do
          post base_url, params: invalid_event_params
        end.not_to change(Event, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        # Com dry-validation, o formato da mensagem de erro mudou
        expect(json_response["errors"]).to have_key("title")
        expect(json_response["errors"]).to have_key("event_type")
      end
    end
  end

  describe "PUT /api/v1/events/:id" do
    let!(:event) { create(:event, valid_event_params) }
    let(:new_title) { "Updated Event Title" }
    let(:update_params) { { id: event.id, title: new_title, event_type: event.event_type } }

    context "when the event exists" do
      it "updates the event" do
        put "#{base_url}/#{event.id}", params: update_params

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response["id"]).to eq(event.id)
        expect(json_response["title"]).to eq(new_title)
        expect(event.reload.title).to eq(new_title)
      end
    end

    context "when the event does not exist" do
      it "returns a 404 error" do
        put "#{base_url}/999", params: update_params.merge(id: 999)

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Event not found")
      end
    end

    context "with invalid parameters" do
      it "does not update the event and returns errors" do
        put "#{base_url}/#{event.id}", params: {
          id: event.id,
          title: "",
          event_type: "invalid_type"
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
      end
    end
  end

  describe "DELETE /api/v1/events/:id" do
    let!(:event) { create(:event, valid_event_params) }

    context "when the event exists" do
      it "deletes the event" do
        expect do
          delete "#{base_url}/#{event.id}"
        end.to change(Event, :count).by(-1)

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["message"]).to eq("Event successfully deleted")
      end
    end

    context "when the event does not exist" do
      it "returns a 404 error" do
        delete "#{base_url}/999"

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["error"]).to eq("Event not found")
      end
    end
  end
end