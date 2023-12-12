class LinkEphemeral < Link
    validates :visited, inclusion: [true, false]

    def meets_condition_for_display?
        if !(self.visited)
            result = { success: true }
        else
            result = { success: false, http_status: 403 }
        end
        
        result 
    end

    def update_conditions
       self.visited = true
       self.save
    end
end
