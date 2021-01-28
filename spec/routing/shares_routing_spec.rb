require "rails_helper"

RSpec.describe SharesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/shares").to route_to("shares#index")
    end

    it "routes to #show" do
      expect(get: "/shares/1").to route_to("shares#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/shares").to route_to("shares#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/shares/1").to route_to("shares#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/shares/1").to route_to("shares#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/shares/1").to route_to("shares#destroy", id: "1")
    end
  end
end
