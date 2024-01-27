class LinkRegular < Link
    def to_partial_path
        #'links/link_regular'
        'link'
    end  
 
    def meets_condition_for_display? (password = nil)
        return true
    end
end
