class HikingResponse
  class Route
    attr_reader :title,
                :subtitle,
                :start_location,
                :end_location,
                :distance_km,
                :estimated_duration,
                :difficulty,
                :elevation_gain_m,
                :why_it_matches,
                :description,
                :highlights,
                :tips,
                :weather,
                :accommodations,
                :external_links

    def initialize(data)
      @title = data["title"]
      @subtitle = data["subtitle"]
      @start_location = data["start_location"]
      @end_location = data["end_location"]
      @distance_km = data["distance_km"]
      @estimated_duration = data["estimated_duration"]
      @difficulty = data["difficulty"]
      @elevation_gain_m = data["elevation_gain_m"]
      @why_it_matches = data["why_it_matches"]
      @description = data["description"]
      @highlights = data["highlights"] || []
      @tips = data["tips"] || []
      @weather = data["weather"]
      @accommodations = data["accommodations"] || []
      @external_links = data["external_links"] || []
    end
  end

  attr_reader :intro, :routes, :follow_up_question

  def initialize(data)
    @intro = data["intro"]
    @routes = (data["routes"] || []).map { |route| Route.new(route) }
    @follow_up_question = data["follow_up_question"]
  end

  def self.from_json(json)
    data = JSON.parse(json)
    new(data)
  end
end