%{
    MIT License

    Copyright (C) 2018, Simon Müller <simon_mb@hotmail.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
%}


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