class SuggestionsController < ApplicationController
    
    get '/suggestions' do
        Suggestion.all.to_json(include: [user: {only: [:username, :city, :state]}], except: [:updated_at])
    end
    
    get "/suggestions/:id" do
        find_suggestion
        if @suggestion
            serialized_suggestion
        else
            {message: "Record not found with id #{params['id']}"}.to_json
        end
    end
    
    post "/suggestions" do
        @suggestion = Suggestion.create(params)
        if @suggestion.id
            serialized_suggestion
        else
            {message: @suggestion.errors.full_messages.to_sentence}.to_json
        end
    end

    patch "/suggestions/:id" do
        find_suggestion
        if @suggestion&.update(params)
            serialized_suggestion
        elsif !@suggestion
            {message: "Record not found with id #{params['id']}"}.to_json
        else
            {message: @suggestion.errors.full_messages.to_sentence}.to_json
        end
    end
    
    delete '/suggestions/:id' do
        find_suggestion
        if @suggestion&.destroy
            {message: "Record successfully destroyed"}.to_json
        else
            {message: "Record not found with id #{params['id']}"}.to_json
        end
    end

    private

    def find_suggestion
        @suggestion = Suggestion.find_by_id(params["id"])
    end
    
    def serialized_suggestion
        @suggestion.to_json(include: [user: {only: [:username, :city, :state]}])
    end

end