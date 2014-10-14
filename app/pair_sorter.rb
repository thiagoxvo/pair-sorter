class Sorter
  attr_reader :people

  def initialize opts
    raise ArgumentError, 'People not sent' if opts[:people].nil?
    raise ArgumentError, 'Teams not sent' if opts[:teams].nil?
    raise ArgumentError, 'At least 4 people are necessary' if opts[:people].size < 4 
    raise ArgumentError, 'An even number of people are necessary' if opts[:people].size.odd?
    @people = opts[:people]
    @teams = opts[:teams]
    initialize_pairs
    generate_statistics
  end

  def switch_pairs
    @rotations += 1
    if (@rotations % @half_people).zero?
     switch_rows
     @teams = @teams.rotate
     
    end

    if @rotations.odd?
      sort_second_row
    else
      sort_first_row
    end

    generate_statistics
    current_pairs
    
  end

  def current_pairs
    [@first_row, @second_row, @teams].transpose
  end

  def generate_statistics
    @stats ||= []
    @stats.push current_pairs
  end  
  
  def count_statistics
    pairs = {}
    @stats.flatten(1).each do |pair| 
      reverse_pair =  pair.select{|e| e.is_a? Numeric}.reverse.push(pair.last)
      if pairs[pair].nil? && pairs[reverse_pair].nil?
        pairs[pair] = 1
      else
        pairs[pair] += 1 unless pairs[pair].nil?
        pairs[reverse_pair] += 1 unless pairs[reverse_pair].nil?
      end
    end
    pairs
  end  

  private
  def initialize_pairs
    @rotations = 0
    @half_people = @people.size / 2
    people_splited = @people.each_slice(@half_people).to_a
    @first_row = people_splited.first
    @second_row = people_splited.last
    generate_statistics
  end

  def sort_first_row
    @first_row.unshift(@first_row.pop)
  end

  def sort_second_row
    @second_row.push(@second_row.shift)
  end

  def switch_rows
    first_row_element = @first_row.shift
    @first_row.unshift @second_row.shift
    @second_row.unshift first_row_element
  end

end