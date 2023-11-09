require "rails_helper"

RSpec.describe "Api::V1::Operations", type: :request do
  describe "GET /" do
    context "when auth token is not provided" do
      it "returns unauthorized" do
        get "/"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when auth token is invalid" do
      let(:access_token) { SecureRandom.hex }

      it "returns unauthorized" do
        get "/", headers: { Authorization: "Token token=#{access_token}" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when auth token is valid" do
      let(:api_key) { create(:api_key) }
      let(:access_token) { api_key.access_token }

      context "when 'expression' param is missing" do
        it "returns bad_request status" do
          get "/", headers: { Authorization: "Token token=#{access_token}" }

          expect(response).to be_bad_request
        end

        it "returns correct error" do
          get "/", headers: { Authorization: "Token token=#{access_token}" }

          expect(api_response["error"]).to eq("param is missing or the value is empty: expression")
        end
      end

      context "when 'expression' param is provided" do
        let(:valid_part) { "2+10/2-1*3" }
        let(:result) { 4 }

        before do
          get "/", headers: { Authorization: "Token token=#{access_token}" }, params: { expression: expression }
        end

        context "with valid expression" do
          let(:expression) { valid_part }

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end

          it "returns correct fields" do
            expect(api_response.keys).to match(%w[expression result])
          end

          it "computes result of the expression" do
            expect(api_response["expression"]).to eq(expression)
            expect(api_response["result"]).to eq(result)
          end
        end

        context "with partially valid expression" do
          let(:expression) { "34%3k#{valid_part} 7+3" }

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end

          it "computes result of the valid part of the expression" do
            expect(api_response["expression"]).to eq(valid_part)
            expect(api_response["result"]).to eq(result)
          end
        end

        context "with invalid expression" do
          let(:expression) { "2(2)-" }

          it "returns http success" do
            expect(response).to have_http_status(:success)
          end

          it "returns an empty result" do
            expect(api_response["expression"]).to be_empty
            expect(api_response["result"]).to be_nil
          end
        end
      end
    end
  end
end
