#!/usr/bin/env ruby
require '../lib/local_message/local_message_router'
require '../lib/local_message/local_message_user'

router = LocalMessageRouter.new('5500')
router.start