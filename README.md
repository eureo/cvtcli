# Cvtcli

## Installation

Add this line to your application's Gemfile:

    gem 'cvtcli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cvtcli

## Usage

```ruby
class CandidatesController < ApplicationController
  
  def update
    @candidate = current_candidate      
    if @candidate.update_attributes(params[:candidate])
      Cvtcli.sync(params[:candidate])
      redirect_to candidate_path(current_candidate), :notice => t('candidates.flash.updated')
    else
      @candidate.languages.build if @candidate.languages.size == 0
      render :edit
    end
  end

  def delete

  end
end
```
