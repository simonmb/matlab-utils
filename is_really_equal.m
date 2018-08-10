function isE = is_really_equal(a, b)
	%%
	%% Amplifies the isequal function from matlab
	%% adding the capability to check whether to structures have same values
	%% a, b: variables

    isE = isequal(a, b);
    
    if isE
        isE = 1;
        return
    end
    
    if isstruct(a)
        if ~isstruct(b)
            isE = 0;
            return
        end
        
        fn = fieldnames(a);

        if isequal(fn, fieldnames(b))
            for i = 1:length(fn)
                if isstruct(a.(fn{i}))
                    isE = is_really_equal(a.(fn{i}), b.(fn{i}));
                    
                    if ~isE
                       return 
                    end
                else
                    
                    if length(a.(fn{i})) > 1
                        isE = is_really_equal(a.(fn{i}), b.(fn{i}));
                    elseif isnan(a.(fn{i}))
                        if isnan(isnan(b.(fn{i})))
                            isE = 1;
                        else
                            isE = 0;
                            return
                        end
                    else
                        isE = isequal(a.(fn{i}), b.(fn{i}));  
                        
                        if ~isE
                           return 
                        end                      
                    end
                end
            end
        else
            isE = 0;
            return
        end
        
    end
end