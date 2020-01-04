return pl.class({

    _init = function (self)
      self.awful_bad = 1073741823
      self.inf_bad = 10000
      self.eject_penalty = -self.inf_bad
      self.deplorable = 100000
    end,

    collateVboxes = function(_, vboxlist)
      local output = SILE.nodefactory.newVbox({nodes = {} })
      output:append(vboxlist)
      return output
    end,

    findBestBreak = function(self, options)
      local vboxlist = SU.required(options, "vboxlist", "in findBestBreak")
      local target   = SU.required(options, "target", "in findBestBreak")
      local restart  = options.restart or false
      local force    = options.force or false
      local i = 0
      local totalHeight = SILE.length.new()
      local bestBreak = nil
      local started = false
      if restart and restart.target == target then
        totalHeight = restart.totalHeight
        i = restart.i
        started = restart.started
      end
      local leastC = self.inf_bad
      SU.debug("pagebuilder", "Page builder for frame "..SILE.typesetter.frame.id.." called with "..#vboxlist.." nodes, "..target)
      if SU.debugging("vboxes") then
        for j = 1,#vboxlist do
          SU.debug("vboxes", (j==i and " -> " or "    ")..j..": "..vboxlist[j])
        end
      end
      while not started and i < #vboxlist do
        i = i + 1
        if not vboxlist[i]:isVglue() then
          started = true
          i = i - 1
          break
        end
      end
      local pi
      while i < #vboxlist do
        i = i + 1
        local vbox = vboxlist[i]
        SU.debug("pagebuilder", "Dealing with VBox " .. vbox)
        if (vbox:isVbox()) then
          totalHeight = totalHeight + vbox.height + vbox.depth
        elseif vbox:isVglue() then
          totalHeight = totalHeight + vbox.height
        elseif vbox.type == "insertionVbox" then
          target = SILE.insertions.processInsertion(vboxlist, i, totalHeight, target)
          vbox = vboxlist[i]
        end
        local left = target - totalHeight.length
        SU.debug("pagebuilder", "I have " .. tostring(left) .. "pts left")
        -- if (left < -20) then SU.error("\nCatastrophic page breaking failure!"); end
        pi = 0
        if vbox:isPenalty() then
          pi = vbox.penalty
          -- print("PI "..pi)
        end
        if vbox:isPenalty() and vbox.penalty < self.inf_bad  or (vbox:isVglue() and i > 1 and not vboxlist[i-1].discardable) then
          local badness
          SU.debug("pagebuilder", "totalHeight " .. totalHeight .. " with target " .. target)
          if totalHeight.length < target then -- TeX #1039
            -- Account for infinite stretch?
            badness = SU.rateBadness(self.inf_bad, left, totalHeight.stretch)
            -- print("Height == "..totalHeight.length, "target=="..target, "stretch=="..totalHeight.stretch)
          elseif left < totalHeight.shrink then badness = self.awful_bad
          else badness = SU.rateBadness(self.inf_bad, -left, totalHeight.shrink)
          end

          local c
          if badness < self.awful_bad then
            if pi <= self.eject_penalty then c = pi
            elseif badness < self.inf_bad then c = badness + pi -- plus insert
            else c = self.deplorable
            end
        else c = badness end
        if c < leastC then
          leastC = c
          bestBreak = i
        else
          restart = { totalHeight = totalHeight, i = i, started = started, target = target}
        end
        -- print("Badness "..badness .." c = "..c)
        SU.debug("pagebuilder", "Badness: "..c)
        if c == self.awful_bad or pi <= self.eject_penalty then
          SU.debug("pagebuilder", "outputting")
          local onepage = {}
          if not bestBreak then bestBreak = i end
          for j=1,bestBreak do
            onepage[j] = table.remove(vboxlist,1)
          end
          while(#onepage > 1 and onepage[#onepage].discardable) do onepage[#onepage] = nil end
          return onepage, pi
        end
      end
    end
    SU.debug("pagebuilder", "No page break here")
    if force and bestBreak then
      local onepage = {}
      for j=1,bestBreak do
        onepage[j] = table.remove(vboxlist,1)
      end
      return onepage, pi
    end
    return false, restart
  end

})
