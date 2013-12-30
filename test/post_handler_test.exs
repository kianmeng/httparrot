defmodule HTTParrot.PostHandlerTest do
  use ExUnit.Case
  import :meck
  import HTTParrot.PostHandler

  setup do
    new HTTParrot.GeneralRequestInfo
    new JSEX
    new :cowboy_req
  end

  teardown do
    unload HTTParrot.GeneralRequestInfo
    unload JSEX
    unload :cowboy_req
  end

  test "returns json with general info and POST form data" do
    expect(:cowboy_req, :body_qs, 1, {:ok, :body_qs, :req2})
    expect(:cowboy_req, :set_resp_body, [{[:response, :req3], :req4}])
    expect(HTTParrot.GeneralRequestInfo, :retrieve, 1, {[:info], :req3})
    expect(JSEX, :encode!, [{[[:info, {:form, :body_qs}, {:data, ""}, {:json, nil}]], :response}])

    assert post_form(:req1, :state) == {true, :req4, nil}

    assert validate HTTParrot.GeneralRequestInfo
  end

  test "returns json with general info and POST JSON body data" do
    expect(:cowboy_req, :body, 1, {:ok, :body, :req2})
    expect(:cowboy_req, :set_resp_body, [{[:response, :req3], :req4}])
    expect(HTTParrot.GeneralRequestInfo, :retrieve, 1, {[:info], :req3})
    expect(JSEX, :decode!, 1, :decoded_json)
    expect(JSEX, :encode!, [{[[:info, {:form, [{}]}, {:data, :body}, {:json, :decoded_json}]], :response}])

    assert post_json(:req1, :state) == {true, :req4, nil}

    assert validate HTTParrot.GeneralRequestInfo
  end
end
