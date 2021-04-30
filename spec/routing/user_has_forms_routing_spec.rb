require "rails_helper"

RSpec.describe UserHasFormsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_has_forms").to route_to("user_has_forms#index")
    end

    it "routes to #show" do
      expect(get: "/user_has_forms/1").to route_to("user_has_forms#show", id: "1")
    end

    it "routes to #create" do
      expect(post: "/user_has_forms").to route_to("user_has_forms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_has_forms/1").to route_to("user_has_forms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_has_forms/1").to route_to("user_has_forms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_has_forms/1").to route_to("user_has_forms#destroy", id: "1")
    end
  end
end
