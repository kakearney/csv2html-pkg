function csv2html(csvfile, htmlfile, format)
%CSV2HTML Create html table from csv file
%
% % csv2html(csvfile, htmlfile)
% csv2html(csvfile, htmlfile, format)
%
% Input variables:
%
%   csvfile:    csv filename
%
%   htmlfile:   name for output html file
%
%   format:     Printing format.  This only affects the appearance of the
%               text file, but does not have any effect on the resulting
%               table
%               'normal':   Will print one line of text per row (default)
%               'compact':  Will print all cells to one line
%               'long':     Will print one line per cell

% Copyright 2008 Kelly Kearney


if nargin < 3
    format = 'normal';
end

data = readtext(csvfile, ',', '', '"');

isnum = cellfun(@isnumeric, data);
isquoted = false(size(data));
isquoted(~isnum) = regexpfound(data(~isnum), '^".*"$');
data(isquoted) = regexprep(data(isquoted), '^"', '');
data(isquoted) = regexprep(data(isquoted), '"$', '');

[nrow, ncol] = size(data);

fid = fopen(htmlfile, 'wt');
fprintf(fid, '<table>\n');

switch format
    case 'normal'
        for irow = 1:nrow
            fprintf(fid, '<tr>\n');
            for icol = 1:ncol
                if isempty(data{irow,icol})
                    fprintf(fid, '<td></td>');
                elseif isnumeric(data{irow,icol})
                    fprintf(fid, '<td>%g</td>', data{irow,icol});
                else
                    fprintf(fid, '<td>%s</td>', data{irow,icol});
                end
            end
            fprintf(fid, '\n');
        end
    case 'long'
        for irow = 1:nrow
            fprintf(fid, '  <tr>\n');
            for icol = 1:ncol
                if isempty(data{irow,icol})
                    fprintf(fid, '    <td></td>\n');
                elseif isnumeric(data{irow,icol})
                    fprintf(fid, '    <td>%g</td>\n', data{irow,icol});
                else
                    fprintf(fid, '    <td>%s</td>\n', data{irow,icol});
                end
            end
        end
    case 'compact'
        for irow = 1:nrow
            fprintf(fid, '<tr>');
            for icol = 1:ncol
                if isempty(data{irow,icol})
                    fprintf(fid, '<td></td>');
                elseif isnumeric(data{irow,icol})
                    fprintf(fid, '<td>%g</td>', data{irow,icol});
                else
                    fprintf(fid, '<td>%s</td>', data{irow,icol});
                end
            end
        end
end
fprintf(fid, '\n</table>');