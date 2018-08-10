function whos_detailed_structure(structure, fid, recursive, indentation)
	%%
	%% Shows detailed information on the size in memory of a structure
	%% strucure: the structure to be analized
	%% fid: (optional) file id to write to
	%% recursive: (optional) if a field of 'structure' is a structure this will also be analyzed in detail
	%% indentation: (optional) set the indentation level for the printing


    if ~isstruct(structure)
        error('Input parameter needs to be a structure');
    end

    if nargin == 1 || isempty(fid)
        fid = 1;
    end

    if ~exist('indentation', 'var')
        indentation = 0;
    end
    if ~exist('recursive', 'var')
        recursive = 0;
    end

    indent = '';

    n_structure = length(structure);
    s_structure = whos('structure');

    if indentation == 0
        fprintf(fid,'Structure array with length %i.\n', n_structure);
        fprintf(fid,'Total space used: %s\n', Bytes2humanReadable(s_structure.bytes));
        indentation = indentation + 1;
    end
    
    names = fieldnames(structure);
    all_fields_size = 0;
    for i_field = 1:length(names)
        this_field = names{i_field};
        
        if isstruct(structure(1).(this_field)) && recursive
            temp_val = [structure.(this_field)];
            s_temp_val = whos('temp_val');
            all_fields_size = all_fields_size + s_temp_val.bytes;
            fprintf(fid,'%s%s: %s (%.2f)\n', GetIndent(indentation), this_field, Bytes2humanReadable(s_temp_val.bytes), s_temp_val.bytes / s_structure.bytes);
            whos_detailed_structure(temp_val, fid, recursive, indentation + 1)
        else
            field_size = 0;
            for i_structure = 1:n_structure
                temp_val = structure(i_structure).(this_field);
                s_temp_val = whos('temp_val');
                field_size = field_size + s_temp_val.bytes;
                all_fields_size = all_fields_size + s_temp_val.bytes;
            end
            fprintf(fid,'%s%s: %s (%.2f)\n', GetIndent(indentation), this_field, Bytes2humanReadable(field_size), field_size / s_structure.bytes);
        end
    end
    indentation = indentation - 1;
    
    if indentation == 0
        fprintf(fid,'Total space used by fields: %s (%.2f)\n', Bytes2humanReadable(all_fields_size), all_fields_size / s_structure.bytes);
    end

    function human_readable_str = Bytes2humanReadable(n_bytes)
        
        orderOfMagnitude = floor(log(n_bytes)/log(1024));
        switch orderOfMagnitude
            case 0
                human_readable_str = [sprintf('%.0f',n_bytes) ' b'];
            case 1
                human_readable_str = [sprintf('%.2f',n_bytes/(1024)) ' kb'];
            case 2
                human_readable_str = [sprintf('%.2f',n_bytes/(1024^2)) ' Mb'];
            case 3
                human_readable_str = [sprintf('%.2f',n_bytes/(1024^3)) ' Gb'];
            case 4
                human_readable_str = [sprintf('%.2f',n_bytes/(1024^4)) ' Tb'];
            case -inf
                % Size occasionally returned as zero (eg some Java objects).
                human_readable_str = 'matlab returned wrong value!';
            otherwise
               human_readable_str = 'too large';
        end
    end

    function indent = GetIndent(n)
        indent = '';
        for i = 1:n
            indent = [indent '    '];
        end 
    end

end