// const purgecss = require('@fullhuman/postcss-purgecss')({
//   content: ['./app/components/**/*.html.erb', './app/views/**/*.html.erb', './app/helpers/**/*.rb'],
//   defaultExtractor: content => content.match(/[A-Za-z0-9-_:/]+/g) || []
// })

module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('tailwindcss')('./app/javascript/tailwind.js'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
    //...(process.env.NODE_ENV === 'production' ? [purgecss] : [])
  ]
}
