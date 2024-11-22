return {
  'Exafunction/codeium.vim',
  config = function ()
    -- Change '<C-g>' here to any keycode you like.
    vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
}

-- eyJhbGciOiJSUzI1NiIsImtpZCI6IjFlNTIxYmY1ZjdhNDAwOGMzYmQ3MjFmMzk2OTcwOWI1MzY0MzA5NjEiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiaGFvIHlhbmciLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZXhhMi1mYjE3MCIsImF1ZCI6ImV4YTItZmIxNzAiLCJhdXRoX3RpbWUiOjE3MzIxNTMxMzQsInVzZXJfaWQiOiIxWGY3RnFqOG5nTkVnVjVqRDZrNWNLMWNIdjgyIiwic3ViIjoiMVhmN0ZxajhuZ05FZ1Y1akQ2azVjSzFjSHY4MiIsImlhdCI6MTczMjE2MjA3MCwiZXhwIjoxNzMyMTY1NjcwLCJlbWFpbCI6InloMzkyMjYxMjI2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJlbWFpbCI6WyJ5aDM5MjI2MTIyNkBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.YFmV3kb1VEYB3dlCGoITxC83guVEihZuCWLxg_3_eW-LVEiVSvTlATcRdJbxIEyoyjgT_QyU4BoaZ2iZxWmnl0XGL9ElVwTfYDNbwXC-QD5TqEonYWQuJODTKEJ5fxI7XUw7WkUERojW3b64ssVt6hDLwH3mrnS9Fkq23Qr5FWIc1-SQzJBnrJgB3LpU1Ocf_lLKo2eYZ7-53tOxxnZ_iOgJx1Z6dDcIa7h12KK9kznQzOGuvKACcyhva7AlxlCHCrPbjQtmmJt3CczVBdv3URjg789h5iRZIrtQGVN0IuI0-oS3FUacxG8tBBWeIggMYrRirMOfG2WURDNMwoJOhQ