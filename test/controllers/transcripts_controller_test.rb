require "test_helper"

class TranscriptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transcript = transcripts(:one)
  end

  test "should get index" do
    get transcripts_url
    assert_response :success
  end

  test "should get new" do
    get new_transcript_url
    assert_response :success
  end

  test "should create transcript" do
    assert_difference("Transcript.count") do
      post transcripts_url, params: { transcript: { input: @transcript.input, output: @transcript.output, status: @transcript.status, uuid: @transcript.uuid } }
    end

    assert_redirected_to transcript_url(Transcript.last)
  end

  test "should show transcript" do
    get transcript_url(@transcript)
    assert_response :success
  end

  test "should get edit" do
    get edit_transcript_url(@transcript)
    assert_response :success
  end

  test "should update transcript" do
    patch transcript_url(@transcript), params: { transcript: { input: @transcript.input, output: @transcript.output, status: @transcript.status, uuid: @transcript.uuid } }
    assert_redirected_to transcript_url(@transcript)
  end

  test "should destroy transcript" do
    assert_difference("Transcript.count", -1) do
      delete transcript_url(@transcript)
    end

    assert_redirected_to transcripts_url
  end
end
