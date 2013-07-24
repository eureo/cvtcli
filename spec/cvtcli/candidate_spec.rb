require 'spec_helper'
require 'json'

describe Cvtcli::Candidate do
  before do
  end

  describe "#create" do
    let(:email) { 'franck.dagostini@gmail.com' }
    let(:params) { { candidate: { "email"=> email}} }
    let(:candidate) { Cvtcli::Candidate.new }
    context "when remote candidate does not exist" do
      it "creates it" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.create(email, params)
          candidate.last_response.should match(/candidate/)
        end
      end
      after(:each) do
        candidate.delete(email)
      end
    end
    context "when remote candidate exist" do
      it "retrieves the candidate" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.create(email, params)
          candidate.create(email, params)
          candidate.last_response.should match(/candidate/)
        end
      end
    end
    after(:each) do
      candidate.delete(email)
    end
  end

  describe "#delete" do
    let(:email) { 'franck.dagostini@gmail.com' }
    let(:params) { { candidate: { "email"=> email}} }
    let(:candidate) { Cvtcli::Candidate.new }
    context "when remote candidate exists" do
      it "delete it" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.create(email, params)
          candidate.delete(email)
          candidate.last_response.should match(/candidate/)
        end
      end
    end
    context "when remote candidate does not exist" do
      it "returns nil" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.delete(email)
          candidate.last_response.should be_nil
        end
      end
    end

  end

  describe "#sync" do
    let(:file) { File.new(File.join(File.dirname(__FILE__), '..', 'support', 'avatars', 'avatar.jpg')) }
    let(:email) { 'franck.dagostini@gmail.com' }
    let(:params) { { candidate: { "gender"=>"mister", "firstname"=>"Franck", "lastname"=>"D'agostini", "email" => email, avatar: file }} }
    let(:candidate) { Cvtcli::Candidate.new }
    let(:params_with_resumes) { { 'candidate' => { 'email' => email, 'resumes_attributes' => {'0' => { 'title' => 'Un titre de CV', "file" => resume_file1}, '1' => { 'title' => 'Un autre CV', 'file' => resume_file2}}}} }
    let(:resume_file1) { File.new(File.join(File.dirname(__FILE__), '..', 'support', 'resumes', 'resume.pdf')) }
    let(:resume_file2) { File.new(File.join(File.dirname(__FILE__), '..', 'support', 'resumes', 'resume.pdf')) }

    context "when candidate does not exist" do
      it "it creates it" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.sync(email, params)
          candidate.last_response.should match(/candidate/)
        end
      end

      it "creates it with resumes" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.sync(email, params_with_resumes)
          candidate.last_response.should match(/Un titre de CV/)
        end
      end

      after(:each) do
        candidate.delete(email)
      end
    end

    context "when candidate does exist" do
      let(:params2) { { candidate: { "firstname"=>"Francky", "email" => email }} }
      before do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.create(email, params)
        end
      end

      it "updates it" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.last_response.should_not match(/Francky/)
          candidate.sync(email, params2)
          candidate.last_response.should match(/Francky/)
        end
      end

      it "updates the resumes" do
        with_configuration(host: 'ce.lvh.me', port: 3000, token: "18fda68e062f6688a0da89943a14ada8") do
          candidate.sync(email, params_with_resumes)
          candidate.last_response.should match(/Un titre de CV/)
          candidate.last_response.should match(/resume\.pdf/)
        end
      end

      after(:each) do
        candidate.delete(email)
      end
    end

  end
end
