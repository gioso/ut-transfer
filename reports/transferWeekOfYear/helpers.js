var {evalResult, formatNumber} = require('ut-report/assets/script/common');

module.exports = {
    transformCellValue: function({allowHtml, nodeContext, dateFormat, locale}) {
        return (value, field, data, isHeader) => {
            var classNames = ['cell'];
            var result = value;
            switch (field.name) {
                case 'agreatepredicate':
                case 'transferCount':
                case 'transferCurrency':
                    break;
                default:
                    if (!isHeader && value) {
                        result = formatNumber(value.toString().replace(/\s\%$/, '')); // format & remove '%'
                        classNames.push('textColorBlue');
                    }
                    classNames.push('rightAlign');
                    break;
            }
            if (allowHtml) {
                return evalResult(result, 'div', classNames, nodeContext);
            }
            return result;
        };
    }
};
