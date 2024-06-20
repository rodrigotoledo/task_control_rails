require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#completed_count" do
    let(:model) { class_double("Project") }

    context "when completed_count is greater than 0" do
      it "returns a span with bg-green-500 class" do
        allow(model).to receive(:completed_count).and_return(15)

        result = helper.completed_count(model)

        expect(result).to include("bg-green-500")
      end
    end

    context "when completed_count is 0" do
      it "returns a span with bg-red-500 class" do
        allow(model).to receive(:completed_count).and_return(0)

        result = helper.completed_count(model)

        expect(result).to include("bg-red-500")
      end
    end

    context "when completed_count is less than 0" do
      it "returns a span with bg-red-500 class" do
        allow(model).to receive(:completed_count).and_return(-1)

        result = helper.completed_count(model)

        expect(result).to include("bg-red-500")
      end
    end
  end
end
