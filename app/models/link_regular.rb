class LinkRegular < Link
    def to_partial_path
        #'links/link_regular'
        'link'
    end  
 
    def meets_condition_for_display?
        return true
    end

    def update_conditions
    end
end
