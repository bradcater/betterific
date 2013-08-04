require 'betterific'

BETTERIFIC_COMMENT_ID = 121 #:nodoc
BETTERIFIC_TAG_ID = 400937 #:nodoc
BETTERIF_ID = 224 #:nodoc
USER_ID = 2 #:nodoc

SEARCH_KINDS = %w{betterifs tags users}.freeze #:nodoc

def ensure_valid_api_response(resp, client_modjule, opts={})
  unless opts[:comments]
    if opts[:big]
      resp.total_results.should > 10
    else
      resp.total_results.should >= (opts[:allow_empty] ? 0 : 1)
    end
  end
  if opts[:big]
    resp.num_results.should == 10
  else
    resp.num_results.should >= (opts[:allow_empty] ? 0 : 1)
  end
  if opts[:betterifs]
    if opts[:big]
      resp.betterifs.size.should == 10
    else
      resp.betterifs.size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    unless opts[:allow_empty]
      if client_modjule == Betterific::JsonClient
        resp.betterifs.first.tags.is_a?(Array).should == true
      elsif client_modjule == Betterific::ProtobufClient
        resp.betterifs.first.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
      elsif client_modjule != Betterific::Client
        raise "Invalid client_modjule #{client_modjule}"
      end
      if resp.betterifs.first.tags.size > 0
        if client_modjule == Betterific::ProtobufClient
          resp.betterifs.first.tags.first.is_a?(BetterIf::Tag).should == true
        end
      end
      if client_modjule == Betterific::ProtobufClient
        resp.betterifs.first.user.is_a?(BetterIf::User).should == true
      end
    end
  end
  if opts[:comments]
    if opts[:big]
      resp.comments.size.should == 10
    else
      resp.comments.size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    if client_modjule == Betterific::JsonClient
      resp.comments.is_a?(Array).should == true
    elsif client_modjule == Betterific::ProtobufClient
      resp.comments.is_a?(ProtocolBuffers::RepeatedField).should == true
    elsif client_modjule != Betterific::Client
      raise "Invalid client_modjule #{client_modjule}"
    end
    if client_modjule == Betterific::ProtobufClient && resp.comments.size > 0
      resp.comments.first.is_a?(BetterIf::Comment).should == true
    end
  end
  if opts[:tags]
    if opts[:big]
      resp.tags.size.should == 10
    else
      resp.tags.size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    if client_modjule == Betterific::JsonClient
      resp.tags.is_a?(Array).should == true
    elsif client_modjule == Betterific::ProtobufClient
      resp.tags.is_a?(ProtocolBuffers::RepeatedField).should == true
    elsif client_modjule != Betterific::Client
      raise "Invalid client_modjule #{client_modjule}"
    end
    if client_modjule == Betterific::ProtobufClient && resp.tags.size > 0
      resp.tags.first.is_a?(BetterIf::Tag).should == true
    end
  end
  if opts[:users]
    if opts[:big]
      resp.users.size.should == 10
    else
      resp.users.size.should >= (opts[:allow_empty] ? 0 : 1)
    end
    if client_modjule == Betterific::JsonClient
      resp.users.is_a?(Array).should == true
    elsif client_modjule == Betterific::ProtobufClient
      resp.users.is_a?(ProtocolBuffers::RepeatedField).should == true
    elsif client_modjule != Betterific::Client
      raise "Invalid client_modjule #{client_modjule}"
    end
    if client_modjule == Betterific::ProtobufClient && resp.users.size > 0
      resp.users.first.is_a?(BetterIf::User).should == true
    end
  end
end

def client_test(modjule)
  describe modjule do
    [['without page params', {}],
     ['with page params', {:page => 2, :per_page => 1}]].each do |(page_params_lbl, page_params)|
      describe page_params_lbl do
        [:most_popular, :most_recent].each do |filter|
          it "should load #{filter} betterifs" do
            resp = modjule.betterifs(page_params.merge(:filter => filter))
            ensure_valid_api_response(resp, modjule, :betterifs => true, :big => page_params.empty?)
          end
        end
        it "should load betterifs via ids" do
          resp = modjule.betterifs(page_params.merge(:ids => BETTERIF_ID))
          ensure_valid_api_response(resp, modjule, :betterifs => true, :allow_empty => !page_params.empty?)
          if page_params.empty?
            resp.betterifs.first.id.should == BETTERIF_ID
          end
        end
        it "should load comments via ids" do
          resp = modjule.comments(page_params.merge(:ids => BETTERIFIC_COMMENT_ID))
          ensure_valid_api_response(resp, modjule, :comments => true, :allow_empty => !page_params.empty?)
          if page_params.empty?
            resp.comments.first.id.should == BETTERIFIC_COMMENT_ID
          end
        end
        it "should load tags via ids" do
          resp = modjule.tags(page_params.merge(:ids => BETTERIFIC_TAG_ID))
          ensure_valid_api_response(resp, modjule, :tags => true, :allow_empty => !page_params.empty?)
          if page_params.empty?
            resp.tags.first.id.should == BETTERIFIC_TAG_ID
          end
        end
        it "should load users via ids" do
          resp = modjule.users(page_params.merge(:ids => USER_ID))
          ensure_valid_api_response(resp, modjule, :users => true, :allow_empty => !page_params.empty?)
          if page_params.empty?
            resp.users.first.id.should == USER_ID
          end
        end
  
        SEARCH_KINDS.each do |kind|
          it "should load search for #{kind}" do
            q = [random_query, random_query].join(' ')
            resp = modjule.search(page_params.merge(:namespace => kind, :q => q))
            resp.q.should == q
            ensure_valid_api_response(resp.send(kind), modjule, kind.to_sym => true, :allow_empty => true)
            if modjule == Betterific::JsonClient
              SEARCH_KINDS.each do |other_kind|
                next if kind == other_kind
                resp.send(other_kind).present?.should == false
              end
            end
          end
        end
        it "should load search for all" do
          q = [random_query, random_query].join(' ')
          resp = modjule.search(page_params.merge(:namespace => :all, :q => q))
          resp.q.should == q
          SEARCH_KINDS.each do |kind|
            ensure_valid_api_response(resp.send(kind), modjule, kind.to_sym => true, :allow_empty => true)
          end
        end
      end
    end
  end
end

def random_query
  'abcdefghijklmnopqrstuvwxyz'.split(//).sample
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
